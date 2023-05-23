#include <fcntl.h>
#include <mqueue.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#include "sum.h"

char *HELP = "A tool for threaded summing of long numbers\n"
             "sum v1.0.0 <mara.schulke@th-brandenburg.de>\n"
             "\n"
             "sum <number> <chunksize> <workers>\n"
             "\n"
             "Arguments:\n"
             "\tnumber:\t\tNumber to sum up to (1+2+..+n)\n"
             "\tchunksize:\tSize of chunks dispatched to workers to compute\n"
             "\tworkers:\tAmount of threaded workers to use for computation\n";

void help() {
    printf("%s", HELP);
    exit(1);
}

int main(int argc, char **argv) {
    if (argc != 4) {
        help();
        return 1;
    }

    long n;
    int chunksize;
    int workers;

    if (sscanf(argv[1], "%li", &n) == 0) {
        fprintf(stderr, "Unable to parse long number from: %s\n", argv[1]);
        exit(1);
    }

    if (sscanf(argv[2], "%d", &chunksize) == 0) {
        fprintf(stderr, "Unable to parse chunksize from: %s\n", argv[2]);
        exit(1);
    }

    if (sscanf(argv[3], "%d", &workers) == 0) {
        fprintf(stderr, "Unable to parse worker count from: %s\n", argv[3]);
        exit(1);
    }

    printf("Number: %li\n", n);
    printf("Chunksize: %d\n", chunksize);
    printf("Workers: %d\n", workers);

    mqd_t mq;
    struct mq_attr attr;
    attr.mq_flags = 0;
    attr.mq_maxmsg = MQ_MAX_MSG_COUNT;
    attr.mq_msgsize = MQ_MAX_MSG_SIZE;
    attr.mq_curmsgs = 0;

    pid_t pid = getpid();
    char mq_path[128];
    sprintf(mq_path, "/sum.%d", pid);
    printf("using %s\n", mq_path);

    mq = mq_open(mq_path, O_RDWR | O_CREAT, 0644, &attr);

    if (mq == (mqd_t)-1) {
        perror("mq_open");
        exit(1);
    }

    for (int i = 1; i <= n; i += chunksize) {
        int start = i;
        int end = i + chunksize - 1;

        if (end > n) {
            end = n;
        }

        char msg[256];

        sprintf(msg, "%s %d..%d", MSG_TYPE_SUM, start, end);

        if (mq_send(mq, msg, strlen(msg), 0) == -1) {
            perror("failed to dispatch message to queue");
            exit(1);
        }

        printf("(send) -> %s\n", msg);
    }

    for (int i = 0; i < workers; i++) {
        if (mq_send(mq, MSG_TYPE_DIE, strlen(MSG_TYPE_DIE), 0) == -1) {
            perror("failed to dispatch die message to queue");
            exit(1);
        }
    }

    mq_close(mq);

    return 0;
}
