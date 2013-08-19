/*
   *
   *
   *
 */
#include <Timer.h>
#include "RadioTest.h"

configuration RadioTestAppC {
}
implementation {
  components MainC;
  components LedsC;
  components RadioTestC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_RADIOTEST);
  components UserButtonC;
  components new AMReceiverC(AM_RADIOTEST);

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Packet -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.Button->UserButtonC.Notify;
}
