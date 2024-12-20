// Mara Schulke, 20215853, 11.06.2023

#include <fcntl.h>
#include <mqueue.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#include "ipc.h"

void get_resource_path(char path[128], const char prefix[], const char type[]) {
    sprintf(path, "%s.%d.%s", prefix, getpid(), type);
}

/// Creates a message queue
mqd_t create_mq(char path[]) {
    mqd_t mq;

    struct mq_attr attr;
    attr.mq_flags = 0;
    attr.mq_maxmsg = MQ_MAX_MSG_COUNT;
    attr.mq_msgsize = MQ_MAX_MSG_SIZE;
    attr.mq_curmsgs = 0;

    mq = mq_open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR, &attr);

    if (mq == (mqd_t)-1) {
        perror("mq_open");
        exit(1);
    }

    return mq;
}

/// Drops a message queue
void drop_mq(mqd_t mq) {
    if (mq_close(mq) == -1) {
        perror("mq_close");
        exit(1);
    }
}

/// Destroys a message queue
void destroy_mq(char path[]) {
    if (mq_unlink(path) == -1) {
        perror("mq_unlink");
        exit(1);
    }
}

/// Creates and maps a shared memory segment
long *create_shm(char path[]) {
    int shm_fd;
    long *shm_ptr;

    shm_fd = shm_open(path, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
    if (shm_fd == -1) {
        perror("shm_open");
        exit(1);
    }

    if (ftruncate(shm_fd, SHM_SIZE) == -1) {
        perror("ftruncate");
        exit(1);
    }

    shm_ptr =
        mmap(NULL, SHM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);

    if (shm_ptr == MAP_FAILED) {
        perror("mmap");
        exit(1);
    }

    return shm_ptr;
}

/// Drops and unmaps a shared memory segment
void drop_shm(long *shm_ptr) {
    if (munmap(shm_ptr, SHM_SIZE) == -1) {
        perror("munmap");
        exit(1);
    }
}

/// Destroys a shared memory segment
void destroy_shm(char path[]) {
    if (shm_unlink(path) == -1) {
        perror("shm_unlink");
        exit(1);
    }
}

/// Creates a semaphore
sem_t *create_sem(char path[]) {
    sem_t *sem = sem_open(path, O_CREAT, S_IRUSR | S_IWUSR, 1);

    if (sem == SEM_FAILED) {
        perror("sem_open");
        exit(1);
    }

    return sem;
}

/// Drops a semaphore
void drop_sem(sem_t *sem) {
    if (sem_close(sem) == -1) {
        perror("sem_close");
        exit(1);
    }
}

/// Destroys a semaphore
void destroy_sem(char path[]) {
    if (sem_unlink(path) == -1) {
        perror("sem_unlink");
        exit(1);
    }
}
