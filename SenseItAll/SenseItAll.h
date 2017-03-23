
#ifndef SENSEITALL_H
#define SENSEITALL_H

#define BASE_STATION_ID	1
#define SENSOR_ID	10

enum {
  AM_BLINKTORADIO = 6,
  TIMER_PERIOD_MILLI = 250
};

typedef nx_struct _SenseItAllMsg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
  nx_uint16_t temp;
  nx_uint16_t hum;
} SenseItAllMsg;

#endif
