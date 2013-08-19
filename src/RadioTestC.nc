/* 
   *
   *
   *
 */

#include <Timer.h>
#include "RadioTest.h"
#include"UserButton.h"
#include"CommonQueue.h"

module RadioTestC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface AMSend;
  uses interface Packet;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Notify<button_state_t> as Button;
}

implementation {

  uint16_t counter = 0;
  message_t pkt;
  bool busy = FALSE;
  nx_int16_t led2offcnt;

  QueueElement testqueue;
  TestStruct testqueuelist[10];

  TestStruct delmsg;


  uint16_t targetmote,targettemp;

  task void sendDataTask();
/*******************************************************************
				Boot
  *******************************************************************/
  event void Boot.booted() 
  {
  //  call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    call AMControl.start();

	call Button.enable();
  }

  event void Button.notify(button_state_t val)
  {
	  if (val == BUTTON_PRESSED)
	  {
		  TestStruct addmsg;

		  initQueue(&testqueue,&testqueuelist,10);

		  addmsg.nodeid = 0x0102;
		  addmsg.counter = 0x0304;

		  addQueue(&testqueue,&addmsg,sizeof(addmsg));

		  deleteQueue(&testqueue,&delmsg,sizeof(delmsg));

		  targetmote = 299;

		  post sendDataTask();
	  }
  }

/*******************************************************************
				
  *******************************************************************/
  event void AMControl.startDone(error_t err) 
  {
    if (err != SUCCESS) 
    {
      call AMControl.start();
    }
	else
	{
		call Leds.led1On();
		targettemp = 201;
		call Timer0.startPeriodic(200);
	}
  }
  
  event void AMControl.stopDone(error_t err) 
  {		
  }

/*******************************************************************
				
  *******************************************************************/
  event void AMSend.sendDone(message_t* msg, error_t err) 
  {
    if (&pkt == msg) 
    {
      busy = FALSE;
      led2offcnt += 1;
	  call Leds.led2Off();

	  if (targetmote == 0xffff)
	  {
	    if (targettemp == 201)
		{
		 targettemp = targetmote = 202;

		}
		else
		{
		 targettemp = targetmote = 201;
		}

		post sendDataTask();
	  }

    }
  }

/*******************************************************************
				
  *******************************************************************/
 event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len)
  {
    if (len == sizeof(RadioTransmitterMsg)) 
    {
      RadioTransmitterMsg* btrpkt = (RadioTransmitterMsg*)payload;

    }
    return msg;
  }

/*******************************************************************
				
  *******************************************************************/
task void sendDataTask()
{
      if (!busy) 
      {
		RadioTransmitterMsg* btrpkt = (RadioTransmitterMsg*)(call Packet.getPayload(&pkt, sizeof(RadioTransmitterMsg)));
		btrpkt->nodeid = delmsg.nodeid;
		btrpkt->counter = delmsg.counter;

        if (call AMSend.send(targetmote, &pkt, sizeof(RadioTransmitterMsg)) == SUCCESS) 
		{
			 busy = TRUE;

			 call Leds.led2On();
		}
      }  

}



  event void Timer0.fired()
  {
	 // call Leds.led0Toggle();
	   targetmote = 0xffff;
	   post sendDataTask();
  }




}
