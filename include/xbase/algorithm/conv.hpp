#pragma once
#include "xbase/xbasedef.h"
#include <cstdint>
#include <string>
#include <vector>
#include <locale>
#include <codecvt>

namespace xbase {
namespace algorithm {

template <typename T>
std::wstring to_utf16(const std::basic_string<T>& utf16);
template <typename T>
std::string to_utf8(const std::basic_string<T>& utf8);

template<>
std::wstring to_utf16(const std::basic_string<wchar_t>& utf16)
{
    return utf16;
}
template<>
std::wstring to_utf16(const std::basic_string<char>& utf8)
{
    std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>, wchar_t> convert;
    return convert.from_bytes(utf8);
}

template<>
std::string to_utf8(const std::basic_string<wchar_t>& utf16)
{
    std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>, wchar_t> convert;
    return convert.to_bytes(utf16);
}
template<>
std::string to_utf8(const std::basic_string<char>& utf8)
{
    return utf8;
}

// Hex
template<typename T>
std::basic_string<T> toHex(uint8_t c)
{
    static const char* val = "0123456789abcdef";
    T buf[3] = { 0, 0, 0 };
    buf[0] = (T)val[(c >> 4) & 0xF];
    buf[1] = (T)val[(c & 0xF) >> 4];
    return buf;
}

template<typename T>
std::basic_string<T> toHex(const uint8_t* p, size_t cb)
{
    std::basic_string<T> s;
    s.reserve(cb * 2 + 1);
    while (cb)
        s.append(toHex<T>(p[i]));
    return s;
}

template<typename T>
std::basic_string<T> toHex(uint16_t c)
{
    std::basic_string<T> result;
    const uint8_t* p = (const uint8_t*)&c;
#ifdef _WIN32
    result += toHex<T>(p[1]);
    result += toHex<T>(p[0]);
#else
    result += toHex<T>(p[0]);
    result += toHex<T>(p[1]);
#endif
    return result;
}

template<typename T>
std::basic_string<T> toHex(uint32_t c)
{
    std::basic_string<T> result;
    const uint8_t* p = (const uint8_t*)&c;
#ifdef _WIN32
    result += toHex<T>(p[3]);
    result += toHex<T>(p[2]);
    result += toHex<T>(p[1]);
    result += toHex<T>(p[0]);
#else
    result += toHex<T>(p[0]);
    result += toHex<T>(p[1]);
    result += toHex<T>(p[2]);
    result += toHex<T>(p[3]);
#endif
    return result;
}

template<typename T>
std::basic_string<T> toHex(uint64_t c)
{
    std::basic_string<T> result;
    const uint8_t* p = (const uint8_t*)&c;
#ifdef _WIN32
    result += toHex<T>(p[7]);
    result += toHex<T>(p[6]);
    result += toHex<T>(p[5]);
    result += toHex<T>(p[4]);
    result += toHex<T>(p[3]);
    result += toHex<T>(p[2]);
    result += toHex<T>(p[1]);
    result += toHex<T>(p[0]);
#else
    result += toHex<T>(p[0]);
    result += toHex<T>(p[1]);
    result += toHex<T>(p[2]);
    result += toHex<T>(p[3]);
    result += toHex<T>(p[4]);
    result += toHex<T>(p[5]);
    result += toHex<T>(p[6]);
    result += toHex<T>(p[7]);
#endif
    return result;
}

// escape/unescape rules:
//  https://tools.ietf.org/html/rfc7159#page-8
template<typename T>
std::basic_string<T> escape(const std::basic_string<T>& s)
{
    std::basic_string<T> s2;
    const T* pos = s.c_str();
    while (*pos)
    {
        switch (*pos)
        {
        case T('\"'):
            s2.append(1, T('\\'));
            s2.append(1, T('\"'));
            break;
        case T('\\'):
            s2.append(2, T('\\'));
            break;
        case T('/'):
            s2.append(1, T('\\'));
            s2.append(1, T('/'));
            break;
        case T('\b'):
            s2.append(1, T('\\'));
            s2.append(1, T('b'));
            break;
        case T('\f'):
            s2.append(1, T('\\'));
            s2.append(1, T('f'));
            break;
        case T('\n'):
            s2.append(1, T('\\'));
            s2.append(1, T('n'));
            break;
        case T('\r'):
            s2.append(1, T('\\'));
            s2.append(1, T('r'));
            break;
        case T('\t'):
            s2.append(1, T('\\'));
            s2.append(1, T('t'));
            break;
        default:
            s2.append(pos, 1);
            break;
        }
        ++pos;
    }
    return s2;
}

template<typename T>
std::basic_string<T> unescape(const std::basic_string<T>& s)
{
    std::basic_string<T> s2;
    const T* pos = s.c_str();
    while (*pos)
    {
        if (*pos == T('\\'))
        {
            // escaped character
            ++pos;
            if (*pos == T('\"'))
            {
                s2.append(1, T('\"'));
                ++pos;
            }
            else if (*pos == T('\\'))
            {
                s2.append(1, T('\\'));
                ++pos;
            }
            else if (*pos == T('/'))
            {
                s2.append(1, T('/'));
                ++pos;
            }
            else if (*pos == T('b'))
            {
                s2.append(1, T('\b'));
                ++pos;
            }
            else if (*pos == T('f'))
            {
                s2.append(1, T('\f'));
                ++pos;
            }
            else if (*pos == T('n'))
            {
                s2.append(1, T('\n'));
                ++pos;
            }
            else if (*pos == T('r'))
            {
                s2.append(1, T('\r'));
                ++pos;
            }
            else if (*pos == T('t'))
            {
                s2.append(1, T('\t'));
                ++pos;
            }
            else
            {
                s2.append(pos, 1);
                ++pos;
            }
        }
        else
        {
            s2.append(pos, 1);
            ++pos;
        }
    }
    return std::move(s2);
}

}}