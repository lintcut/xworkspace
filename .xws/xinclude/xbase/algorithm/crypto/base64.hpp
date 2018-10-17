#pragma once
#include <cstdint>
#include <string>
#include <vector>

namespace xbase {
namespace algorithm {

struct base64 {

    static std::string encode(const void* data, size_t size) noexcept
    {
    }

    static std::vector<uint8_t> decode(const std::string& sb64) throw(std::invalid_argument)
    {
    }

};

}}