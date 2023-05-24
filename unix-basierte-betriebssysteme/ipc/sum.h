#ifndef SUM_H
#define SUM_H

#include <mqueue.h>

// Message Queue

#define SUM_MQ_PREFIX "/sum"
#define SUM_MQ_MAX_MSG_SIZE 256
#define SUM_MQ_MAX_MSG_COUNT 10

mqd_t init_mq();
void drop_mq(mqd_t mq);

// Requests

enum RequestType { SUM, DIE };

typedef struct SumPayload {
    long from;
    long to;
} SumPayload;

typedef struct Request {
    enum RequestType type;
    union {
        SumPayload sumPayload;
    } payload;
} Request;

int msg_enc(char out[], const Request req);
int msg_dec(Request out, const char msg[]);

#endif
