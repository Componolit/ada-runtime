/*
 * Copyright (C) 2018 Componolit GmbH
 *
 * This file is part of the Componolit Ada runtime, which is distributed
 * under the terms of the GNU Affero General Public License version 3.
 *
 * As a special exception under Section 7 of GPL version 3, you are granted
 * additional permissions described in the GCC Runtime Library Exception,
 * version 3.1, as published by the Free Software Foundation.
 */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

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
        ptr = malloc(size) + size;
        (void) pthread_setspecific(key, ptr);
    }

    return pthread_getspecific(key);
}

void *get_thread() {
    return (void *)pthread_self();
}

void raise_ada_exception(int exception, char *name, char *message) {
    printf("Exception raised (%d): %s: %s\n", exception, name, message);
    exit(0);
}

#define LOG(type) void log_##type(char *message) { \
    printf( #type ": %s\n", message); \
}

LOG(debug)
LOG(warning)
LOG(error)

void put_char (const char c) {
   putc(c, stdout);
}

void put_int (const int i) {
   printf("%d", i);
}
