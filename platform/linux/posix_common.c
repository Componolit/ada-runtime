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
#include <assert.h>
#include <time.h>
#include <ada_exceptions.h>
#include <componolit_runtime.h>

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

void componolit_runtime_allocate_secondary_stack(unsigned size, void **address) {
    void *ptr;

    (void) pthread_once(&key_once, make_key);
    if ((ptr = pthread_getspecific(key)) == NULL) {
        ptr = malloc(size) + size;
        (void) pthread_setspecific(key, ptr);
    }

    *address = pthread_getspecific(key);
}

void componolit_runtime_raise_ada_exception(exception_t exception, char *name, char *message) {
    printf("Exception raised (%d): %s: %s\n", (int)exception, name, message);
    exit(0);
}

#define LOG(type) void componolit_runtime_log_##type(char *message) { \
    printf( #type ": %s\n", message); \
}

LOG(debug)
LOG(warning)
LOG(error)


void componolit_runtime_initialize(void)
{ }

void componolit_runtime_finalize(void)
{ }
