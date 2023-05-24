#ifndef SUM_H
#define SUM_H

#include <mqueue.h>

// Message Queue

#define SUM_MQ_PREFIX "/sum"
#define SUM_MQ_MAX_MSG_SIZE 256
#define SUM_MQ_MAX_MSG_COUNT 10

mqd_t init_mq();
void drop_mq(mqd_t mq);

#endif
