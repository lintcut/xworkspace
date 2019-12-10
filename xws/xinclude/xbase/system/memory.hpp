#pragma once
#include "xbase/xbasedef.h"

namespace xbase {
namespace system {

template<typename T>
struct MemoryRegion
{
    T base;
    uint32_t size;
};

}}
