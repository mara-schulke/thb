// Mara Schulke, 20215853, 19.05.2023

#include <mqueue.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "ipc.h"
#include "req.h"
#include "sum.h"

int main(int argc, char **argv) {
    /// Parsing argv

    char mq_path[128];
    char shm_path[128];
    char sem_path[128];

    if (argc > 1 && strcmp(argv[1], "-id") == 0) {
        if (argc != 3) {
            fprintf(stderr, "no id supplied\n");
            exit(1);
        }

        int id;

        if (sscanf(argv[2], "%d", &id) == 0) {
            fprintf(stderr, "unable to parse id from: %s\n", argv[1]);
            exit(1);
        }

        sprintf(mq_path, "%s.%d.%s", SUM_UNIQUE_PREFIX, id, SUM_MQ_SUFFIX);
        sprintf(shm_path, "%s.%d.%s", SUM_UNIQUE_PREFIX, id, SUM_SHM_SUFFIX);
        sprintf(sem_path, "%s.%d.%s", SUM_UNIQUE_PREFIX, id, SUM_SEM_SUFFIX);
    } else {
        fprintf(stderr, "no id supplied\n");
        fflush(stderr);
        exit(1);
    }

    /// IPC Initialization

    mqd_t mq = create_mq(mq_path);
    long *shm = create_shm(shm_path);
    sem_t *sem = create_sem(sem_path);

    /// Memory Initialization

    long result = 0;
    int req_c = 0;

    pid_t pid = getpid();
    char buffer[MQ_MAX_MSG_SIZE + 1];
    ssize_t bytes_read;

    /// Request Loop

    while (1) {
        /// Recieving requests

        bytes_read = mq_receive(mq, buffer, MQ_MAX_MSG_SIZE, NULL);
        if (bytes_read == -1) {
            perror("mq_receive");
            exit(1);
        }

        buffer[bytes_read] = '\0';

        /// Decoding requests

        Request req;

        if (req_dec(&req, buffer)) {
            fprintf(stderr, "failed to parse message\n");
            fflush(stderr);
            exit(1);
        }

        /// Executing requests

        long local = 0;

        switch (req.type) {
        case SUM:
            /// Computing sum

            for (long i = req.payload.sumPayload.from;
                 i <= req.payload.sumPayload.to; i++) {
                local += i;
            }

            result += local;

            break;
        case DIE:
            /// Commiting the result

            sem_wait(sem);
            *shm += result;
            sem_post(sem);

            /// IPC Cleanup

            drop_mq(mq);
            drop_shm(shm);
            drop_sem(sem);

            /// Exiting

            printf("%d: done after %d requests\n", pid, req_c);
            exit(0);
        }

        req_c++;
    }

    return 0;
}
