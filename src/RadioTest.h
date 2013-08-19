/*
   *
   *
   *
*/

#ifndef RADIOTEST_H
#define RADIOTEST_H

enum {
  AM_RADIOTEST = 40,
  TIMER_PERIOD_MILLI = 1000,

  SINK_NODE_ID = 600,
};

typedef nx_struct RadioTransmitterMsg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
} RadioTransmitterMsg;

typedef struct _TestStruct_ {
  uint16_t nodeid;
  uint16_t counter;
} TestStruct;



#endif
