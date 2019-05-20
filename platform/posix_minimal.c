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

#include <stdlib.h>
#include <stdio.h>
#include <unwind.h>

void *__gnat_malloc(size_t size) {
    return malloc(size);
}

void __gnat_free(void *ptr) {
    free(ptr);
}

_Unwind_Reason_Code __gnat_personality_v0(int version,
                                          void *phases,
                                          _Unwind_Exception_Class class,
                                          void *exception,
                                          void *context)
{
    fprintf(stderr, "%s not implemented\n", __func__);
    exit(1);
}
