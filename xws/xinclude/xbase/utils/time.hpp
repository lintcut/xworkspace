#pragma once
#include <cstdint>
#include <chrono>
#include <string>
#include <ctime>
#include <iomanip>
#ifdef _WIN32
#include <Windows.h>
#endif

namespace xbase {
namespace utils {

class xtimespan
{
public:
    xtimespan()
        : span(0)
    {
    }
    xtimespan(int64_t milliseconds)
        : span(milliseconds)
    {
    }
    xtimespan(const xtimespan& s)
        : span(s)
    {
    }

    xtimespan& operator = (const xtimespan& rh)
    {
        if (this != &rh)
            span = rh.span;
        return *this;
    }

    static xtimespan secondSpan(int64_t seconds)
    {
        return xtimespan(1000 * seconds);
    }

    static xtimespan minuteSpan(int64_t minutes)
    {
        return xtimespan(1000 * 60 * minutes);
    }

    static xtimespan hourSpan(int64_t hours)
    {
        return xtimespan(1000 * 60 * 60 * hours);
    }

    static xtimespan daySpan(int64_t days)
    {
        return xtimespan(1000 * 60 * 60 * 24 * days);
    }

    ~xtimespan() {}

    operator int64_t () const { return span; }

private:
    // milliseconds
    int64_t span;
};

// Refer to: https://en.wikipedia.org/wiki/Lists_of_time_zones
//    - List of time zones by country (https://en.wikipedia.org/wiki/List_of_time_zones_by_country)
//    - List of time zones by UTC offset (https://en.wikipedia.org/wiki/List_of_UTC_time_offsets)
//    - List of time zone abbreviations (https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations)
//    - List of tz database time zones (https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
//    - List of military time zones (https://en.wikipedia.org/wiki/List_of_military_time_zones)
class xtimezone
{
public:
    xtimezone()
        : tz(0)
        , dst(false)
    {
    }

    // Time zone offset is between -12:00 and +14:00
    // Refer to: https://en.wikipedia.org/wiki/List_of_UTC_time_offsets
    xtimezone(int32_t xtz, bool dst = false)
        : tz((xtz >= -43200 && xtz <= 50400) ? xtz : 0)
        , dst(dst)
    {
    }

    xtimezone(const xtimezone& xtz)
        : tz(xtz.tz)
        , dst(xtz.dst)
    {
    }

    ~xtimezone()
    {
    }

    static xtimezone current()
    {
        std::time_t now = std::time(NULL);
        std::time_t local = std::mktime(std::localtime(&now));
        std::time_t gmt = std::mktime(std::gmtime(&now));
        return xtimezone(static_cast<int32_t>(local - gmt));
    }

    std::string to_string()
    {
        char buf[8] = { 0 };
        const int32_t abstz = tz < 0 ? (0 - tz) : tz;
        const int32_t tzh = abstz / 3600;
        const int32_t tzm = (abstz % 3600) / 60;
        sprintf_s(buf, "%c%02d:%02d", (tz < 0 ? '-' : '+'), tzh, tzm);
        return buf;
    }

    std::wstring to_wstring()
    {
        const std::string& stz = to_string();
        return std::wstring(stz.begin(), stz.end());
    }

    bool operator == (int32_t seconds) const
    {
        return (seconds == tz);
    }

    bool operator == (const xtimezone& rh)const
    {
        return (rh.tz == tz && dst == rh.dst);
    }

    int32_t seconds() const { return dst ? (tz + 3600) : tz; }
    bool getDst() const { return dst; }
    void setDst(bool set) { dst = set; }

private:
    int32_t tz; // in seconds
    bool dst;
};

class xtime
{
public:
    xtime()
        : t(0)
    {
    }

    xtime(int64_t t)
        : t(t < 0 ? 0 : t)
    {
    }

    xtime(const xtime& rh)
        : t(rh.t)
    {
    }

#ifdef _WIN32
    xtime(const SYSTEMTIME* st)
        : t(xtime::systemTimetoMilliSecondsSince1970(st))
    {
    }

    xtime(const FILETIME* ft)
        : t(xtime::fileTimetoMilliSecondsSince1970(ft))
    {
    }
#endif
    ~xtime() {}

    static xtime now()
    {
        std::chrono::microseconds ms = std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::system_clock::now().time_since_epoch());
        return xtime((int64_t)ms.count());
    }

    static xtime from_tm(std::tm* ptm)
    {
        return xtime((int64_t)std::mktime(ptm));
    }

    static xtime from_timestamp(const std::string& st)
    {
        // from following format
        //    a. GMT:   "yyyy-mm-ddTHH:MM:SSZ"
        //    b. GMT:   "yyyy-mm-ddTHH:MM:SS.mmmZ"
        //    c. LOCAL: "yyyy-mm-dd HH:MM:SS"
        //    d. LOCAL: "yyyy-mm-dd HH:MM:SS.mmm"
        xtime result;
        if (!st.empty()) {
            const bool gmt = (st[st.length() - 1] == 'Z') ? true : false;
            const bool millisec = (std::string::npos != st.find('.'));
            std::tm itm;
            if (gmt) {
                if (millisec) {
                }
                else {
                }
            }
            else {
                if (millisec) {
                }
                else {
                }
            }

            std::istringstream ss(st);
            ss.imbue(std::locale("de_DE.utf-8"));
            ss >> std::get_time(&t, "%Y-%b-%d %H:%M:%S");
            if (ss.fail()) {
                std::cout << "Parse failed\n";
            }
            else {
                std::cout << std::put_time(&t, "%c") << '\n';
            }
        }
        return xtime();
    }

    operator int64_t () const { return t; }
    xtime& operator = (const xtime& rh) { if (this != &rh) t = rh.t; return *this; }
    bool operator == (const xtime& rh) const { return (t == rh.t); }
    xtime& operator + (const xtimespan& span)
    {
        t += (int64_t)span;
        return *this;
    }
    xtime& operator - (const xtimespan& span)
    {
        t -= (int64_t)span;
        return *this;
    }
    void operator += (const xtimespan& span)
    {
        t += (int64_t)span;
    }
    void operator -= (const xtimespan& span)
    {
        t -= (int64_t)span;
    }

    // To Unix Time (seconds since Jan. 1st, 1970, 00:00:00)
    int64_t toUnixTime() const { return (t / 1000000); }
    // To Unix Time (seconds since Jan. 1st, 1970, 00:00:00)
    int64_t toUnixTimeMilliSeconds() const { return t / 1000; }

    // Format
    enum TimeFormat {
        Iso8601 = 0,
        Iso8601MilliSeconds,
        Rfc1123
    };

    std::string to_string(TimeFormat fmt, const xtimezone& tz = xtimezone(0))
    {
        std::time_t tt = toUnixTime() + tz.seconds();
        const std::tm* ptm = std::gmtime(&tt);
        char buf[260] = { 0 };
        char milliSecond[5] = { 0 };
        switch (fmt)
        {
        case Rfc1123:
            if (tz == 0)
                strftime(buf, 260, "%a, %d %b %Y %T GMT", ptm);
            else
                strftime(buf, 260, "%a, %d %b %Y %T", ptm);
            break;
        case Iso8601MilliSeconds:
            sprintf_s(milliSecond, ".%03d", (int)(toUnixTimeMilliSeconds() % 1000));
            if (tz == 0) {
                strftime(buf, 260, "%FT%T", ptm);
                strcat(buf, milliSecond);
                strcat(buf, "Z");
            }
            else {
                strftime(buf, 260, "%F %T", ptm);
                strcat(buf, milliSecond);
            }
            break;
        case Iso8601:
        default:
            if (tz == 0)
                strftime(buf, 260, "%FT%TZ", ptm);
            else
                strftime(buf, 260, "%F %T", ptm);
            break;
        }
        return buf;
    }

    std::wstring to_wstring(TimeFormat fmt, const xtimezone& tz = xtimezone(0))
    {
        std::time_t tt = toUnixTime() + tz.seconds();
        const std::tm* ptm = std::gmtime(&tt);
        wchar_t buf[260] = { 0 };
        wchar_t milliSecond[5] = { 0 };
        switch (fmt)
        {
        case Rfc1123:
            if (tz == 0)
                wcsftime(buf, 260, L"%a, %d %b %Y %T GMT", ptm);
            else
                wcsftime(buf, 260, L"%a, %d %b %Y %T", ptm);
            break;
        case Iso8601MilliSeconds:
            swprintf_s(milliSecond, L".%03d", (int)(toUnixTimeMilliSeconds() % 1000));
            if (tz == 0) {
                wcsftime(buf, 260, L"%FT%T", ptm);
                wcscat(buf, milliSecond);
                wcscat(buf, L"Z");
            }
            else {
                wcsftime(buf, 260, L"%F %T", ptm);
                wcscat(buf, milliSecond);
            }
            break;
        case Iso8601:
        default:
            if (tz == 0)
                wcsftime(buf, 260, L"%FT%TZ", ptm);
            else
                wcsftime(buf, 260, L"%F %T", ptm);
            break;
        }
        return buf;
    }


#ifdef _WIN32
    static FILETIME milliSecondsToFileTime(uint64_t ms)
    {
        FILETIME ft = { 0, 0 };
        // to Milliseconds, since 1601/1/1;
        ms += xtime::milliSecondsBetween1601And1970();
        // to 100-nano seconds, since 1601/1/1
        uint64_t ns = ms * 10000;
        // to FILETIME
        ft.dwHighDateTime = (uint32_t)((ns >> 32) & 0xFFFFFFFF);
        ft.dwLowDateTime = (uint32_t)(ns & 0xFFFFFFFF);
        return ft;
    }

    static SYSTEMTIME milliSecondsToSystemTime(uint64_t ms)
    {
        SYSTEMTIME st = { 0 };
        const FILETIME ft(milliSecondsToFileTime(ms));
        FileTimeToSystemTime(&ft, &st);
        return st;
    }

    static uint64_t fileTimetoMicroSecondsSince1970(const FILETIME* ft)
    {
        // 100-nano seconds, since 1601/1/1
        uint64_t ns = ft->dwHighDateTime;
        ns <<= 32;
        ns += ft->dwLowDateTime;
        // 100-nano seconds,  since 1970/1/1
        ns -= xtime::hundredNanoSecondsBetween1601And1970();
        // Microseconds since 1970/1/1
        ns /= 10;
        return ns;
    }

    static int64_t fileTimetoMilliSecondsSince1970(const FILETIME* ft)
    {
        return (int64_t)(xtime::fileTimetoMicroSecondsSince1970(ft) / 1000);
    }

    static uint64_t systemTimetoMicroSecondsSince1970(const SYSTEMTIME* st)
    {
        FILETIME ft = { 0, 0 };
        SystemTimeToFileTime(st, &ft);
        return xtime::fileTimetoMicroSecondsSince1970(&ft);
    }

    static int64_t systemTimetoMilliSecondsSince1970(const SYSTEMTIME* st)
    {
        FILETIME ft = { 0, 0 };
        SystemTimeToFileTime(st, &ft);
        return xtime::fileTimetoMilliSecondsSince1970(&ft);
    }

    static uint64_t compute100NanoSecondsBetween1601And1970()
    {
        SYSTEMTIME st = { 0 };
        FILETIME ft = { 0, 0 };
        memset(&st, 0, sizeof(st));
        st.wYear = 1970;
        st.wMonth = 1;
        st.wDay = 1;
        SystemTimeToFileTime(&st, &ft);
        uint64_t result = ft.dwHighDateTime;
        result <<= 32;
        result += ft.dwLowDateTime;
        return result;
    }

    static uint64_t hundredNanoSecondsBetween1601And1970()
    {
        static uint64_t result = xtime::compute100NanoSecondsBetween1601And1970();
        return result;
    }

    static uint64_t microSecondsBetween1601And1970()
    {
        static uint64_t result = xtime::hundredNanoSecondsBetween1601And1970() / 10;
        return result;
    }

    static uint64_t milliSecondsBetween1601And1970()
    {
        static uint64_t result = xtime::hundredNanoSecondsBetween1601And1970() / 10000;
        return result;
    }
#endif


private:
    // milliseconds since 1970/1/1 00:00:00
    int64_t t;
};


}}