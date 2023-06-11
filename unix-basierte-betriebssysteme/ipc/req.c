// Mara Schulke, 20215853, 24.05.2023

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "req.h"

void bin_enc(char out[65], long n) {
    int bits = sizeof(n) * 8;
    int i;

    for (i = bits - 1; i >= 0; i--) {
        int bit = (n >> i) & 1;

        if (bit) {
            out[bits - i - 1] = '1';
        } else {
            out[bits - i - 1] = '0';
        }
    }

    out[64] = '\0';
}

long bin_dec(char bin[]) { return strtoul(bin, NULL, 2); }

int req_enc(char out[], const Request req) {
    char star[65];
    char end[65];

    switch (req.type) {
    case SUM:
        bin_enc(star, req.payload.sumPayload.from);
        bin_enc(end, req.payload.sumPayload.to);
        sprintf(out, "SUM %s..%s", star, end);
        return 0;
    case DIE:
        strcpy(out, "DIE");
        return 0;
    }

    return 1;
}

int req_dec(Request *out, const char msg[]) {
    int msg_len = strlen(msg);

    if (msg_len < 3) {
        return 127;
    }

    char type[4];
    strncpy(type, msg, 3);
    type[3] = '\0';

    if (strcmp(type, "DIE") == 0) {
        out->type = DIE;
        return 0;
    }

    if (strcmp(type, "SUM") != 0) {
        return 1;
    }

    char from[65];
    char to[65];

    // Layout "SUM <64>..<64>"
    strncpy(from, msg + 4, 64);
    strncpy(to, msg + 4 + 64 + 2, 64);

    from[64] = '\0';
    to[64] = '\0';

    out->type = SUM;
    out->payload.sumPayload.from = bin_dec(from);
    out->payload.sumPayload.to = bin_dec(to);

    return 0;
}
