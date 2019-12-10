#pragma once
#include "xbase/xbasedef.h"
#include <cstdint>
#include <string>

namespace xbase {
namespace system {

class Process
{
public:
    ~Process();

    static Process* open(uint32_t pid);
    static Process* create();

    std::string getImage() const;
    bool readMemory(uintptr_t address, void* buf, size_t bytesToRead);
    bool writeMemory(uintptr_t address, const void* buf, size_t bytesToWrite);

protected:
    Process(uint32_t pid, void* h);

private:
    uint32_t pid;
    void* h;
};

}}
