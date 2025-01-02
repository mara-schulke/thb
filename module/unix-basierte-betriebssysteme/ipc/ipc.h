#ifndef IPC_H
#define IPC_H

#include <semaphore.h>

#define MQ_MAX_MSG_SIZE 256
#define MQ_MAX_MSG_COUNT 10

#define SHM_SIZE sizeof(long)

void get_resource_path(char path[128], const char prefix[], const char type[]);

mqd_t create_mq(char path[]);
void drop_mq(mqd_t mq);
void destroy_mq(char path[]);

long *create_shm(char path[]);
void drop_shm(long *shm_ptr);
void destroy_shm(char path[]);

sem_t *create_sem(char path[]);
void drop_sem(sem_t *sem);
void destroy_sem(char path[]);

#endif
