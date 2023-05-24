#ifndef REQ_H
#define REQ_H

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

int req_enc(char out[], const Request req);
int req_dec(Request *out, const char msg[]);

#endif
