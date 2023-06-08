#include <fcntl.h>
#include <mqueue.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#include "req.h"
#include "sum.h"

const char *HELP =
    "A tool for threaded summing of long numbers\n"
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

void parse_args(int argc, char **argv, long *n, int *chunksize, int *workers) {
    if (argc != 4) {
        help();
        exit(1);
    }

    if (sscanf(argv[1], "%li", n) == 0) {
        fprintf(stderr, "Unable to parse long number from: %s\n", argv[1]);
        exit(1);
    }

    if (sscanf(argv[2], "%d", chunksize) == 0) {
        fprintf(stderr, "Unable to parse chunksize from: %s\n", argv[2]);
        exit(1);
    }

    if (sscanf(argv[3], "%d", workers) == 0) {
        fprintf(stderr, "Unable to parse worker count from: %s\n", argv[3]);
        exit(1);
    }
}

int main(int argc, char **argv) {
    long n;
    int chunksize;
    int workers;

    parse_args(argc, argv, &n, &chunksize, &workers);

    if (chunksize <= 0) {
        fprintf(stderr, "invalid chunksize supplied\n");
        exit(1);
    }

    if (workers <= 0) {
        fprintf(stderr, "invalid worker count supplied\n");
        exit(1);
    }

    mqd_t mq = init_mq();

    FILE *worker_out[workers];
    char worker_cmd[64];
    snprintf(worker_cmd, sizeof(worker_cmd), "sum_worker -qid %d", getpid());

    for (int i = 0; i < workers; i++) {
        worker_out[i] = popen(worker_cmd, "r");

        if (worker_out[i] == NULL) {
            printf("failed to start worker %d\n", i);
            exit(1);
        }
    }

    for (long i = 1; i <= n; i += chunksize) {
        long start = i;
        long end = i + chunksize - 1;

        if (end > n) {
            end = n;
        }

        char msg[256];

        Request req;
        req.type = SUM;
        req.payload.sumPayload.from = start;
        req.payload.sumPayload.to = end;

        if (req_enc(msg, req)) {
            fprintf(stderr, "unable to encode request %li..%li\n", start, end);
            break;
        }

        if (mq_send(mq, msg, strlen(msg), 0) == -1) {
            perror("failed to dispatch message to queue");
            exit(1);
        }
    }

    char msg[256];
    Request req;
    req.type = DIE;

    if (req_enc(msg, req)) {
        fprintf(stderr, "unable to encode die request\n");
        exit(1);
    }

    for (int i = 0; i < workers; i++) {
        if (mq_send(mq, msg, strlen(msg), 0) == -1) {
            perror("failed to dispatch die message to queue");
            exit(1);
        }
    }

    for (int i = 0; i < workers; i++) {
        char line[1035];

        while (fgets(line, sizeof(line) - 1, worker_out[i]) != NULL) {
            printf("%s", line);
        }
    }

    drop_mq(mq);

    return 0;
}

// ************************************************************************** //

void mq_get_path(char mq_path[128]) {
    sprintf(mq_path, "%s.%d", SUM_MQ_PREFIX, getpid());
}

mqd_t init_mq() {
    mqd_t mq;

    char mq_path[128];
    mq_get_path(mq_path);

    struct mq_attr attr;
    attr.mq_flags = 0;
    attr.mq_maxmsg = SUM_MQ_MAX_MSG_COUNT;
    attr.mq_msgsize = SUM_MQ_MAX_MSG_SIZE;
    attr.mq_curmsgs = 0;

    mq = mq_open(mq_path, O_RDWR | O_CREAT, 0644, &attr);

    if (mq == (mqd_t)-1) {
        perror("mq_open");
        exit(1);
    }

    return mq;
}

void drop_mq(mqd_t mq) {
    mq_close(mq);

    char mq_path[128];
    mq_get_path(mq_path);

    mq_unlink(mq_path);
}

long *init_shm() {
    // https://man7.org/linux/man-pages/man7/shm_overview.7.html
    // https://man7.org/linux/man-pages/man3/shm_open.3.html

    int shmfd;
    long *worker_res;

    char shm_path[128];
    mq_get_path(shm_path);

    shmfd = shm_open(shm_path, O_CREAT | O_EXCL | O_RDWR, S_IRUSR | S_IWUSR);

    if (shmfd == -1) {
        perror("shm_open");
        exit(1);
    }

    if (ftruncate(shmfd, sizeof(long)) == -1) {
        perror("ftruncate");
        exit(1);
    }

    worker_res = mmap(NULL, sizeof(*worker_res), PROT_READ | PROT_WRITE,
                      MAP_SHARED, shmfd, 0);

    if (worker_res == MAP_FAILED) {
        perror("mmap");
        exit(1);
    }

    printf("Shared Memory Wert: %li\n", *worker_res);

    return worker_res;
}

/*void drop_shm(long *shm) { shmdt(shm); }*/
