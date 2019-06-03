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

#include <stdio.h>
#include <stdlib.h>
#include <componolit_runtime.h>
#include <gnat_helpers.h>

_Unwind_Reason_Code __gnat_personality_v0(int version,
                                                   unsigned long phases,
                                                   _Unwind_Exception_Class class,
                                                   void *exception,
                                                   void *context)
{
    fprintf(stderr, "%s not implemented\n", __func__);
    exit(1);
}
