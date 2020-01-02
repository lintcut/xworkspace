#pragma once
#include "xbase/xbasedef.h"
#include <cstdint>
#include <string>
#include <vector>
#include <stdarg.h>

namespace xbase {
namespace algorithm {

template <typename T>
class string_buffer
{
public:
    string_buffer(std::basic_string<T>& s, size_t size)
        : rs(s)
        , buf(size+1, 0)
    {
    }

    ~string_buffer()
    {
        rs = buf.data();
    }

    operator T* () { return buf.data(); }

private:
    std::basic_string<T>& rs;
    std::vector<T> buf;
};

typedef string_buffer<char>     sbuf;
typedef string_buffer<wchar_t>  wsbuf;

template <typename T>
void trim_left(std::basic_string<T>& s)
{
    std::basic_string<T>::size_type pos = 0;
    while (pos < s.length() && iswspace(s[pos]))
        ++pos;
    if (pos > 0)
        s = pos < s.length() ? s.substr(pos) : "";
}

template <typename T>
void trim_right(std::basic_string<T>& s)
{
    std::basic_string<T>::size_type pos = 0;
    while (pos < s.length() && iswspace(s[s.length() - pos - 1]))
        ++pos;
    if (pos > 0)
        s = pos < s.length() ? s.substr(0, s.length() - pos) : "";
}

template <typename T>
void trim(std::basic_string<T>& s)
{
    trim_left(s);
    trim_right(s);
}

template <typename T>
std::basic_string<T> format(const T* fmt, ...);

template <>
std::string format<char>(const char* fmt, ...)
{
    std::vector<char> result;
    va_list ap;
    int n = 255;
    while (1) {
        result.resize(n + 1, 0);
        va_start(ap, fmt);
        const int nRequired = vsnprintf(result.data(), n, fmt, ap);
        va_end(ap);
        if (nRequired >= n)
            n = nRequired;
        else
            break;
    }
    return result.data();
}

template <>
std::wstring format<wchar_t>(const wchar_t* fmt, ...)
{
    std::vector<wchar_t> result;
    va_list ap;
    int n = 255;
    while (1) {
        result.resize(n + 1, 0);
        va_start(ap, fmt);
        const int nRequired = vswprintf(result.data(), n, fmt, ap);
        va_end(ap);
        if (nRequired >= n)
            n = nRequired;
        else
            break;
    }
    return result.data();
}

enum FormatAlignment {
    Left = 0,
    Center,
    Right
};

template <typename T, typename... Args>
std::basic_string<T> format_fixed_width(size_t width, FormatAlignment align, const T* fmt, Args... args)
{
    std::basic_string<T> s = format(fmt, args...);
    if (s.length() >= width)
        return s;
    if (align == Center) {
        size_t left = (width - s.length()) / 2;
        size_t right = width - s.length() - left;
        if (left)
            s = std::basic_string<T>(left,  T(' ')) + s;
        if (right)
            s += std::basic_string<T>(right,  T(' '));

    } else if (align == Right) {
        s = std::basic_string<T>(width - s.length(),  T(' ')) + s;
    } else { // Left
        s += std::basic_string<T>(width - s.length(),  T(' '));
    }
    return s;
}

}}
