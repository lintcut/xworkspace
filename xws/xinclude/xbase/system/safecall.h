#pragma once
#include "xbase/xbasedef.h"

namespace xbase {
namespace win {

template<typename R, typename F, typename... Args>
FORCEINLINE R call(void* fp, Args... args)
{
    return ((F)fp)(args...);
}

template<typename F, typename... Args>
FORCEINLINE void call(void* fp, Args... args)
{
    ((F)fp)(args...);
}

}}
