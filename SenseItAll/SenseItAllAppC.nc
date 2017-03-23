/**
 * @author jachermocilla@gmail.com
 */

#define NEW_PRINTF_SEMANTICS

#include <Timer.h>
#include "SenseItAll.h"
#include "printf.h"


configuration SenseItAllAppC {
}

implementation {
  components MainC;
  components LedsC;
  components SenseItAllC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_BLINKTORADIO);
  components new AMReceiverC(AM_BLINKTORADIO);
  components new SensirionSht11C() as Sensor;

  //printf related
  components PrintfC;
  components SerialStartC;


  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.Read -> Sensor.Temperature;
}
