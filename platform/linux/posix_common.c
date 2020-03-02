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

void componolit_runtime_raise_ada_exception(exception_t exception, char *name, char *message) {
    printf("Exception raised (%d): %s: %s\n", (int)exception, name, message);
    exit(0);
}

void componolit_runtime_log(const char *message) {
    fprintf(stderr, "%s\n", message);
}

void componolit_runtime_initialize(void)
{ }

void componolit_runtime_finalize(void)
{ }
