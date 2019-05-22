#pragma once
#include "xbase/xbasedef.h"
#include <cstdint>
#include <string>
#include <vector>

namespace xbase {
namespace utils {

namespace
{
    // Use current (compile time) as a seed
    constexpr char time[] = __TIME__; // __TIME__ has the following format: hh:mm:ss in 24-hour time

                                      // Convert time string (hh:mm:ss) into a number
    constexpr uint32_t DigitToInt(char c) { return c - '0'; }
    const uint32_t xrndseed = DigitToInt(time[7]) +
        DigitToInt(time[6]) * 10 +
        DigitToInt(time[4]) * 60 +
        DigitToInt(time[3]) * 600 +
        DigitToInt(time[1]) * 3600 +
        DigitToInt(time[0]) * 36000;
}

template<int N>
struct const_randgen
{
private:
    static constexpr uint32_t a = 16807;        // 7^5
    static constexpr uint32_t m = 2147483647;   // 2^31 - 1

    static constexpr uint32_t s = xrandgen<N - 1>::value;
    static constexpr uint32_t lo = a * (s & 0xFFFF);                // Multiply lower 16 bits by 16807
    static constexpr uint32_t hi = a * (s >> 16);                   // Multiply higher 16 bits by 16807
    static constexpr uint32_t lo2 = lo + ((hi & 0x7FFF) << 16);     // Combine lower 15 bits of hi with lo's upper bits
    static constexpr uint32_t hi2 = hi >> 15;                       // Discard lower 15 bits of hi
    static constexpr uint32_t lo3 = lo2 + hi;

public:
    static constexpr uint32_t max = m;
    static constexpr uint32_t value = lo3 > m ? lo3 - m : lo3;
};

template<>
struct const_randgen<0>
{
    static constexpr uint32_t value = xrndseed;
};

template<int N, int M>
struct const_rand
{
    static const int value = const_randgen<N + 1>::value % M;
};

template<int N>
struct const_rand8
{
    static const int8_t value = static_cast<int8_t>( const_rand<N, 0x7F>::value);
};

template<int N>
struct const_rand16
{
    static const int16_t value = static_cast<int16_t>(const_rand<N, 0x7FFF>::value);
};

template<int N>
struct const_rand32
{
    static const int32_t value = static_cast<int32_t>(const_rand<N, 0x7FFFFFFF>::value);
};

template<int N>
struct const_positive_rand8
{
    static const int8_t value = static_cast<int8_t>(1 + const_rand<N, 0x7F - 1>::value);
};

template<int N>
struct const_positive_rand16
{
    static const int16_t value = static_cast<int16_t>(1 + const_rand<N, 0x7FFF - 1>::value);
};

template<int N>
struct const_positive_rand32
{
    static const int32_t value = static_cast<int32_t>(1 + const_rand<N, 0x7FFFFFFF - 1>::value);
};

#define CONST_RAND8()     const_rand8<__COUNTER__>::value
#define CONST_RAND16()    const_rand16<__COUNTER__>::value
#define CONST_RAND32()    const_rand32<__COUNTER__>::value

#define CONST_POSITIVE_RAND8()     const_positive_rand8<__COUNTER__>::value
#define CONST_POSITIVE_RAND16()    const_positive_rand16<__COUNTER__>::value
#define CONST_POSITIVE_RAND32()    const_positive_rand32<__COUNTER__>::value

}}