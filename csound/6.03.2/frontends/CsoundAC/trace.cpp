// trace.cpp -- debugging print function
//
// (I think this was created to provide a generic print function
// for use in non-command-line Windows applications where printf
// does not work. Currently, it is not used, but kept around for
// possible debugging needs. -RBD)

#include "stdarg.h"
#include "stdio.h"
#if defined(MSVC)
#include "crtdbg.h"
#endif


void trace(char *format, ...)
{
    char msg[256];
    va_list args;
    va_start(args, format);
#if defined(MSVC)
    _vsnprintf_s(msg, 256, _TRUNCATE, format, args);
#else
    vsnprintf(msg, 256, format, args);
#endif
    va_end(args);
#if (defined(MSVC) && defined(_DEBUG))
    _CrtDbgReport(_CRT_WARN, NULL, NULL, NULL, msg);
#else
    printf("%s", msg);
#endif
}
