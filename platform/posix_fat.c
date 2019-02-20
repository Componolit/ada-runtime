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

#include <setjmp.h>
#include <sys/time.h>

void _gnat_builtin_longjmp(jmp_buf *env, int val) {
   longjmp(*env, val);
}

void __gnat_timeval_to_duration (struct timeval *tv, time_t *sec, suseconds_t *usec)
{
   *sec = tv->tv_sec;
   *usec = tv->tv_usec;
}
