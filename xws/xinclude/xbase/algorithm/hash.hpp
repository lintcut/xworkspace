#pragma once

#include <cstdint>
#include <vector>

#include <xbase/algorithm/crypto/md5.hpp>
#include <xbase/algorithm/crypto/sha1.hpp>
#include <xbase/algorithm/crypto/sha256.hpp>

namespace xbase
{
namespace algorithm
{

enum HashAlgorithm
{
    MD5 = 0,
    SHA1,
    SHA256
};

template<HashAlgorithm ALG>
class xhash;

template<>
class xhash<MD5>
{
public:
    xhash() : result(16, 0) {}
    ~xhash() {}

    const uint8_t* compute(const void* data, size_t size)
    {
    }

private:
    std::vector<uint8_t> result;
};
typedef xhash<MD5>  xmd5;

template<>
class xhash<SHA1>
{
public:
    xhash() : result(20, 0) {}
    ~xhash() {}

    const uint8_t* compute(const void* data, size_t size)
    {
    }

private:
    std::vector<uint8_t> result;
};
typedef xhash<SHA1>  xsha1;

template<>
class xhash<SHA256>
{
public:
    xhash() : result(32, 0) {}
    ~xhash() {}

    const uint8_t* compute(const void* data, size_t size)
    {
    }

private:
    std::vector<uint8_t> result;
};
typedef xhash<SHA256>  xsha256;

}}