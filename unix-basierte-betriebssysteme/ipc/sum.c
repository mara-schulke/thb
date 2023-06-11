// Mara Schulke, 20215853, 19.05.2023

#include <fcntl.h>
#include <mqueue.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

#include "ipc.h"
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

/// Parses arguments from argv
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

    /// IPC Initialization

    char mq_path[128];
    char shm_path[128];
    char sem_path[128];

    get_resource_path(mq_path, SUM_UNIQUE_PREFIX, SUM_MQ_SUFFIX);
    get_resource_path(shm_path, SUM_UNIQUE_PREFIX, SUM_SHM_SUFFIX);
    get_resource_path(sem_path, SUM_UNIQUE_PREFIX, SUM_SEM_SUFFIX);

    mqd_t mq = create_mq(mq_path);
    long *shm = create_shm(shm_path);
    sem_t *sem = create_sem(sem_path);

    *shm = 0;

    /// Worker Initialization

    char pid[32];
    snprintf(pid, sizeof(pid), "%d", getpid());

    pid_t wpids[workers];

    for (int i = 0; i < workers; i++) {
        pid_t wpid = fork();

        if (wpid == -1) {
            perror("fork");
            exit(1);
        } else if (wpid == 0) {
            char *argv[4] = {SUM_WORKER_COMMAND, "-id", pid, NULL};
            execvp(SUM_WORKER_COMMAND, argv);
        } else {
            wpids[i] = wpid;
        }
    }

    /// Sending Workloads

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

    /// Stopping Workers

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

    /// Wait for workers

    for (int i = 0; i < workers; i++) {
        int status;
        pid_t result = waitpid(wpids[i], &status, 0);

        if (result == -1) {
            perror("waitpid");
            exit(1);
        }

        if (WIFSIGNALED(status)) {
            fprintf(stderr, "worker process stopped through signal: %d\n",
                    WTERMSIG(status));
            exit(1);
        }

        if (WIFEXITED(status) && WEXITSTATUS(status) != 0) {
            fprintf(stderr, "worker process exited with status: %d\n",
                    WEXITSTATUS(status));
            exit(1);
        }
    }

    /// Print the result

    sem_wait(sem);
    printf("result: %li\n", *shm);
    sem_post(sem);

    /// IPC Cleanup

    drop_mq(mq);
    drop_shm(shm);
    drop_sem(sem);

    destroy_mq(mq_path);
    destroy_shm(shm_path);
    destroy_sem(sem_path);

    return 0;
}
