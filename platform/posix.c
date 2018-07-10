#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

void *__gnat_malloc(size_t size) {
    return malloc(size);
}

void __gnat_free(void *ptr) {
    free(ptr);
}

void __gnat_unhandled_terminate() {
    printf("error: unhandled exception\n");
    exit(1);
}

static pthread_key_t key;
static pthread_once_t key_once = PTHREAD_ONCE_INIT;

static void make_key()
{
    (void) pthread_key_create(&key, NULL);
}

void *allocate_secondary_stack(void *thread, size_t size) {
    (void) thread;
    void *ptr;

    (void) pthread_once(&key_once, make_key);
    if ((ptr = pthread_getspecific(key)) == NULL) {
        ptr = malloc(size);
        (void) pthread_setspecific(key, ptr);
    }

    return pthread_getspecific(key);
}

void *get_thread() {
    return (void *)pthread_self();
}

void raise_ada_exception(int exception, char *name, char *message) {
    printf("Exception raised (%d): %s: %s\n", exception, name, message);
}

#define LOG(type) void log_##type(char *message) { \
    printf( #type ": %s\n", message); \
}

LOG(debug)
LOG(warning)
LOG(error)
