#pragma once

#define XBASENAME           "XBase"
#define XBASEVER            "1.0"
#define XBASEDESC           "XBase Library"
#define XBASEVER_MAJOR      1
#define XBASEVER_MINOR      0

#if defined(_MSC_VER)
#ifndef FORCEINLINE
#define FORCEINLINE     __forceinline
#endif
#ifndef NOINLINE
#define NOINLINE        __declspec(noinline)
#endif
#define XBASEALIGN(n)   __declspec(align(n))
#define NORETURN        __declspec(noreturn)
#elif defined(__GNUC__)
#ifndef FORCEINLINE
#define FORCEINLINE     inline __attribute__((always_inline))
#endif
#ifndef NOINLINE
#define NOINLINE        __attribute__((noinline))
#endif
#define XBASEALIGN(n)   __attribute__((__aligned__(n)))
#define NORETURN        __attribute__((__noreturn__))
#else
#error Unsupported compiler
#endif

#define xmin(a, b)      ((a) < (b) ? (a) : (b))
#define xmax(a, b)      ((a) > (b) ? (a) : (b))

#ifndef XADDTOPTR
#define XADDTOPTR(P,I)  ((void*)((unsigned char*)(P) + (I)))
#endif

#ifndef XROUNDTOSIZE
#define XROUNDTOSIZE(_address, _alignment)    \
            (((uintptr_t)(_address) + ((_alignment)-1)) & ~((_alignment) - 1))
#endif

#ifndef XROUNDTOPAGEBASE
#define XROUNDTOPAGEBASE(_address, _alignment)    \
            (((uintptr_t)(_address)) & ~((_alignment) - 1))
#endif

#ifndef XFLAGON
#define XFLAGON(_F,_SF)         ((_F) & (_SF))
#endif

#ifndef XFLAGALLON
#define XFLAGALLON(_F,_SF)      ((_SF) == ((_F) & (_SF)))
#endif

#ifndef XFLAGCLEAR
#define XFLAGCLEAR(_F,_SF)      ((_F) & (~(_SF)))
#endif