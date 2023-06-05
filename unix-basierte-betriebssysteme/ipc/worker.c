#include <mqueue.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "req.h"
#include "sum.h"

int main(int argc, char **argv) {
    char mq_path[128];

    if (argc > 1 && strcmp(argv[1], "-qid") == 0) {
        if (argc != 3) {
            fprintf(stderr, "no queue id supplied\n");
            exit(1);
        }

        int qid;

        if (sscanf(argv[2], "%d", &qid) == 0) {
            fprintf(stderr, "Unable to parse queue id from: %s\n", argv[1]);
            exit(1);
        }

        sprintf(mq_path, "%s.%d", SUM_MQ_PREFIX, qid);
        printf("using supplied queue id %d\n", qid);
    } else {
        pid_t ppid = getppid();
        sprintf(mq_path, "%s.%d", SUM_MQ_PREFIX, ppid);
        printf("using parent process id %d\n", ppid);
        fflush(stdout);
    }

    pid_t pid = getpid();

    mqd_t mq;
    struct mq_attr attr;
    char buffer[SUM_MQ_MAX_MSG_SIZE + 1];
    ssize_t bytes_read;

    attr.mq_flags = 0;
    attr.mq_maxmsg = SUM_MQ_MAX_MSG_COUNT;
    attr.mq_msgsize = SUM_MQ_MAX_MSG_SIZE;
    attr.mq_curmsgs = 0;

    mq = mq_open(mq_path, O_RDONLY | O_CREAT, 0644, &attr);
    if (mq == (mqd_t)-1) {
        perror("mq_open");
        exit(1);
    }

    int req_c = 0;

    while (1) {
        bytes_read = mq_receive(mq, buffer, SUM_MQ_MAX_MSG_SIZE, NULL);
        if (bytes_read == -1) {
            perror("mq_receive");
            exit(1);
        }

        buffer[bytes_read] = '\0';

        Request req;

        if (req_dec(&req, buffer)) {
            printf("failed to parse message");
            fflush(stdout);
            exit(1);
        }

        switch (req.type) {
        case SUM:
            printf("%li + 1 = %li\n", req.payload.sumPayload.from,
                   req.payload.sumPayload.from + 1);
            break;
        case DIE:
            printf("die");
            mq_close(mq);
            printf("%d: handled %d requests\n", pid, req_c);
            return 0;
        }

        req_c++;
    }

    return 0;
}
