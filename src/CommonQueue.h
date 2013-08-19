/*
*
*
*/
/*********************************************************
				 queue element typedef
*********************************************************/
typedef struct _QueueElement_
{
	uint8_t front;
	uint8_t rear;
	uint8_t size;
	void* queue;
}QueueElement;

/*********************************************************
				queue operation
*********************************************************/
	void initQueue(QueueElement* thisqueue,void* queueptr,uint8_t size)
	{
		thisqueue->queue = queueptr;
		thisqueue->size = size;
		thisqueue->front = thisqueue->rear = 0;
	}

	bool isQueueFull(QueueElement* thisqueue)
	{
		if (thisqueue->front == ((thisqueue->rear+1) % thisqueue->size))
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
		
	}

	bool isQueueEmpty(QueueElement* thisqueue)
	{
		if (thisqueue->front == thisqueue->rear)
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}

	void addQueue(QueueElement* thisqueue,void* mem,uint8_t memsize)
	{
		if (!isQueueFull(thisqueue))//if queue is full,pump the new msg
		{
				thisqueue->rear = (thisqueue->rear+1)% thisqueue->size;
				memcpy(thisqueue->queue+thisqueue->rear,mem,memsize);
		}
	}

	//judge if the queue is empty before calling the func
	void deleteQueue(QueueElement* thisqueue,void* mem,uint8_t memsize)
	{
			thisqueue->front = (thisqueue->front+1)% thisqueue->size;		
			memcpy(mem,thisqueue->queue+thisqueue->front,memsize);
	}
	//delete all the element in queue
	void clearQueue(QueueElement* thisqueue)
	{
			thisqueue->front = thisqueue->rear = 0;		
	}
