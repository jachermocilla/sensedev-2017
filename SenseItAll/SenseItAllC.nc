/**
 * @author jachermocilla@gmail.com
 */
#include <Timer.h>
#include "SenseItAll.h"

#include "printf.h"

module SenseItAllC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t>;

}
implementation {

  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;

  void setLeds(uint16_t val) {
    if (val & 0x01)
      call Leds.led0On();
    else 
      call Leds.led0Off();
    if (val & 0x02)
      call Leds.led1On();
    else
      call Leds.led1Off();
    if (val & 0x04)
      call Leds.led2On();
    else
      call Leds.led2Off();
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Leds.led1On();
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
     call Read.read();
  }

  event void Read.readDone(error_t result, uint16_t data){
    //send if this is a sensor node
    if ((TOS_NODE_ID > BASE_STATION_ID) && (result == SUCCESS)){


	//printf("Timer triggered!\n");
    	counter++;
    	if (!busy) {
      		SenseItAllMsg* btrpkt = 
			(SenseItAllMsg*)(call Packet.getPayload(&pkt, sizeof(SenseItAllMsg)));
      		if (btrpkt == NULL) {
			return;
      		}
      		btrpkt->nodeid = TOS_NODE_ID;
      		btrpkt->counter = counter;
                btrpkt->temp = (((data/10)-396)/10);
      		if (call AMSend.send(AM_BROADCAST_ADDR, 
          		&pkt, sizeof(SenseItAllMsg)) == SUCCESS) {
       			busy = TRUE;
      		}
      		printf("Message sent from me node %d!!\n",TOS_NODE_ID);
	}
    }
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    //printf("Message received!\n");

    if (TOS_NODE_ID == BASE_STATION_ID){	
    	if (len == sizeof(SenseItAllMsg)) {
      		SenseItAllMsg* btrpkt = (SenseItAllMsg*)payload;
      		setLeds(btrpkt->counter);
      		//printf("Source Node: %u, Counter: %u\n",btrpkt->nodeid,btrpkt->counter);
      		printf("Temperature received from node %u is %u\n",btrpkt->nodeid, btrpkt->temp);
    	}
    }
    return msg;
  }
}
