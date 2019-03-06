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

char get_char (void) {
   return (char)0;
}

void put_char_stderr (const char c) {
   putc(c, stderr);
}

void put_int (const int i) {
   printf("%d", i);
}

void put_int_stderr (const int i) {
   fprintf(stderr, "%d", i);
}

int get_int (void) {
   return 0;
}

u_int64_t __ada_runtime_rt_resolution(void) {
   int rv;
   struct timespec res;

   rv = clock_getres (CLOCK_MONOTONIC, &res);
   assert(rv == 0);
   return res.tv_sec * 1000000000UL + res.tv_nsec;
}

u_int64_t __ada_runtime_rt_monotonic_clock(void) {
   int rv;
   struct timespec res;

   rv = clock_gettime (CLOCK_MONOTONIC, &res);
   assert(rv == 0);
   return res.tv_sec * 1000000000UL + res.tv_nsec;
}

void __ada_runtime_rt_initialize(void) {
   // empty
}
