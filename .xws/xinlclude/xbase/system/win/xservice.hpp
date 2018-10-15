#pragma once

#include "xbase/xbasedef.h"
#include <cstdint>
#include <string>
#include <vector>
#include <Windows.h>

namespace xb {
namespace win {

class svctrl
{
public:
};

class basic_service
{
public:
    static bool run(basic_service &service)
    {
    }

    basic_service()
    {
    }

    virtual ~basic_service()
    {
    }
};

}}