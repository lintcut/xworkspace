#pragma once

#ifndef STRINGIZER
#define STRINGIZER(x)   #x
#define XSTRINGIZER(x)  STRINGIZER(x)
#endif

#if defined(_MSC_VER)
    #ifndef FORCEINLINE
        #define FORCEINLINE     __forceinline
    #endif
    #ifndef NOINLINE
        #define NOINLINE        __declspec(noinline)
    #endif
    #ifndef XBASEALIGN
        #define XBASEALIGN(n)   __declspec(align(n))
    #endif
    #ifndef NORETURN
        #define NORETURN        __declspec(noreturn)
    #endif
    #ifndef EMIT
        #ifdef _WIN64
            // x64
            #define EMIT(x)     __nop()     // inline asm is not supported by 64bits VC compiler, reserve space only
        #else
            // x86
            #define EMIT(x)     __asm __emit(x)
        #endif
    #endif
#elif defined(__GNUC__)
    #ifndef FORCEINLINE
        #define FORCEINLINE     inline __attribute__((always_inline))
    #endif
    #ifndef NOINLINE
        #define NOINLINE        __attribute__((noinline))
    #endif
    #ifndef XBASEALIGN
        #define XBASEALIGN(n)   __attribute__((__aligned__(n)))
    #endif
    #ifndef NORETURN
        #define NORETURN        __attribute__((__noreturn__))
    #endif
    #ifndef EMIT
        #define EMIT(x)         asm __volatile__ (STRINGIZER(.byte x))
    #endif
#else
    #error Unsupported compiler
#endif

#ifndef __cplusplus
typedef char                int8_t;
typedef short               int16_t;
typedef int                 int32_t;
typedef __int64             int64_t;
typedef unsigned char       uint8_t;
typedef unsigned short      uint16_t;
typedef unsigned int        uint32_t;
typedef unsigned __int64    uint64_t;
#else
#include <cstdint>
#endif

#define XMIN(a, b)      ((a) < (b) ? (a) : (b))
#define XMAX(a, b)      ((a) > (b) ? (a) : (b))

#ifndef FLAGON
#define FLAGON(_F,_SF)      (((_F) & (_SF)) != 0)
#endif

#ifndef BOOLFLAGON
#define BOOLFLAGON(F,SF)    ((bool)(((F) & (SF)) != 0))
#endif

#ifndef SETFLAG
#define SETFLAG(_F,_SF)     ((_F) |= (_SF))
#endif

#ifndef CLEARFLAG
#define CLEARFLAG(_F,_SF)   ((_F) &= ~(_SF))
#endif

#ifndef ALIGNUP
#define ALIGNUP(_Ptr, _Alignment) \
            ((((uintptr_t)(_Ptr)) + ((_Alignment)-1)) & ~(uintptr_t) ((_Alignment) - 1))
#endif

#ifndef ALIGNDOWN
#define ALIGNDOWN(_Ptr, _Alignment) \
            (((uintptr_t)(_Ptr)) & ~(uintptr_t) ((_Alignment) - 1))
#endif

#ifndef ISALIGNED
#define ISALIGNED(_Ptr, _Alignment) \
            ((((uintptr_t)(_Ptr)) & ((_Alignment) - 1)) == 0)
#endif

// return P + V
#ifndef PTRADD
#define PTRADD(P, V)            ((void*)((uintptr_t)(P) + (uintptr_t)(V)))
#endif

// return P - V
#ifndef PTRSUB
#define PTRSUB(P, V)            ((ULONG)((uintptr_t)(P) - (uintptr_t)(P2)))
#endif

// return END - BEGIN
#ifndef PTROFFSET
#define PTROFFSET(BEGIN, END)   ((uint32_t)((uintptr_t)(END) - (uintptr_t)(BEGIN)))
#endif
