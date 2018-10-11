#pragma once
#include "xbase/xbasedef.h"
#include "xbase/utils/rand.hpp"
#include <cstdint>
#include <string>
#include <vector>

namespace xb {
namespace algorithm {

template<size_t... I>
struct index_sequence { using type = index_sequence<I..., sizeof...(I)>; };

template<size_t N>
struct make_index { using type = typename make_index<N - 1>::type::type; };

template<>
struct make_index<0> { using type = index_sequence<>; };

template<typename T, int M, char K, typename I>
struct static_obfuscated_string;

enum ObfuscateMethod {
    ObmXor = 0,
    ObmShift,
    ObmShiftXor
};

template<typename T>
constexpr T FORCEINLINE obfuscate_xor(T c, T k) { return (c ^ k); }

template<typename T>
constexpr T FORCEINLINE obfuscate_lshift(T c, T k, bool xor)
{
    int all = sizeof(T) * 8;
    int s = k % all;
    s = s ? s : (k % (all - 1));
    T result = ((c >> (all - s)) | (c << s));
    return xor ? (result ^ k) : result;
}

template<typename T>
constexpr T FORCEINLINE obfuscate_rshift(T c, T k, bool xor)
{
    int all = sizeof(T) * 8;
    int s = k % all;
    s = s ? s : (k % (all - 1));
    T result = ((c << (all - s)) | (c >> s));
    return xor ? (result ^ k) : result;
}

template<ObfuscateMethod M, char K, size_t... I>
struct static_obfuscated_string<char, M, K, index_sequence<I...>>
{
    // Constructor. Evaluated at compile time.
    constexpr FORCEINLINE static_obfuscated_string(const char* str)
        : decrypted(false)
        , key(K)
        , buffer{ encrypt(str[I])... }
    {
    }

    // Runtime decryption. Most of the time, inlined
    inline const char* c_str()
    {
        if (!decrypted) {
            decrypted = true;
            for (size_t i = 0; i < sizeof...(I); ++i)
                buffer[i] = decrypt(buffer[i]);
            buffer[sizeof...(I)] = 0;
        }
        return const_cast<const char*>(buffer);
    }

private:
    // Encrypt / decrypt a character of the original string with the key
    constexpr char FORCEINLINE encrypt(char c)
    {
        char result = 0;
        switch (M)
        {
        case ObmShift:
            result = ((key % 2) == 1) ? obfuscate_lshift<char>(c, key, false) : obfuscate_rshift<char>(c, key, false);
            break;
        case ObmShiftXor:
            result = ((key % 2) == 1) ? obfuscate_lshift<char>(c, key, true) : obfuscate_rshift<char>(c, key, true);
            break;
        case ObmXor:
        default:
            result = obfuscate_xor<char>(c, key);
            break;
        }
    }

    constexpr char FORCEINLINE decrypt(char c)
    {
        char result = 0;
        switch (M)
        {
        case ObmShift:
            result = ((key % 2) == 1) ? obfuscate_rshift<char>(c, key, false) : obfuscate_lshift<char>(c, key, false);
            break;
        case ObmShiftXor:
            result = ((key % 2) == 1) ? obfuscate_rshift<char>(c, key, true) : obfuscate_lshift<char>(c, key, true);
            break;
        case ObmXor:
        default:
            result = obfuscate_xor<char>(c, key);
            break;
        }
    }

    volatile bool decrypted;
    volatile char key; // key. "volatile" is important to avoid uncontrolled over-optimization by the compiler
    volatile char buffer[sizeof...(I)+1]; // Buffer to store the encrypted string + terminating null byte
};

template<ObfuscateMethod M, typename T, T K>
struct obfuscated_int
{
    // Constructor. Evaluated at compile time.
    constexpr FORCEINLINE obfuscated_int(T n)
        : decrypted(false)
        , key(K)
        , val(encrypt(n))
    {
    }

    FORCEINLINE operator T () const { return decrypt(val); }
    FORCEINLINE T value() const { return decrypt(val); }

private:
    constexpr T FORCEINLINE encrypt(T n)
    {
        char result = 0;
        switch (M)
        {
        case ObmShift:
            result = ((key % 2) == 1) ? obfuscate_lshift<T>(n, key, false) : obfuscate_rshift<T>(n, key, false);
            break;
        case ObmShiftXor:
            result = ((key % 2) == 1) ? obfuscate_lshift<T>(n, key, true) : obfuscate_rshift<T>(n, key, true);
            break;
        case ObmXor:
        default:
            result = obfuscate_xor<T>(n, key);
            break;
        }
    }

    constexpr T FORCEINLINE decrypt(T n)
    {
        char result = 0;
        switch (M)
        {
        case ObmShift:
            result = ((key % 2) == 1) ? obfuscate_rshift<T>(n, key, false) : obfuscate_lshift<T>(n, key, false);
            break;
        case ObmShiftXor:
            result = ((key % 2) == 1) ? obfuscate_rshift<T>(n, key, true) : obfuscate_lshift<T>(n, key, true);
            break;
        case ObmXor:
        default:
            result = obfuscate_xor<T>(n, key);
            break;
        }
    }
    volatile T key;
    volatile T val;
};

#define OBFUSCATEDINT8(V)   obfuscated_int<int8_t, CONST_POSITIVE_RAND8()>(V)
#define OBFUSCATEDINT16(V)  obfuscated_int<int16_t, CONST_POSITIVE_RAND16()>(V)
#define OBFUSCATEDINT32(V)  obfuscated_int<int32_t, CONST_POSITIVE_RAND32()>(V)


}}