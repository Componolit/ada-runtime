
#include <gnat_helpers.h>

extern void exit(int);
extern void Serial;
extern unsigned strlen(const char *);
extern unsigned _ZN14HardwareSerial5writeEPKhj(void *, const unsigned char *, unsigned);

void __gnat_unhandled_terminate()
{
    exit(0);
}

void componolit_runtime_raise_ada_exception(int exception, char *name, char *message)
{
    exit(0);
}

void componolit_runtime_log(const char *message) {
    const unsigned char newline[] = "\r\n\0";
    _ZN14HardwareSerial5writeEPKhj(&Serial, (const unsigned char *)message, strlen(message));
    _ZN14HardwareSerial5writeEPKhj(&Serial, newline, sizeof(newline));
}

_Unwind_Reason_Code __gnat_personality_v0(_Unwind_State state,
                                          void *header,
                                          void *context)
{
    exit(0);
}

void componolit_runtime_initialize(void)
{ }

void componolit_runtime_finalize(void)
{ }
