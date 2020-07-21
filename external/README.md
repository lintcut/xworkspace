# XWORKSPACE EXTERNALS #

This folder contains all third-party libraries and tools supported by xworkspace.

## Why ##

Most of 3rd-party libraries have their own unqiue build procedures (especially on Windows) and many of them don't support static linked library,
and this makes it very difficult to use those libraries in a unified environment. To solve this problem, I get orignal source code and make some changes to let those libraries can be
built under xworkspace environment and reach following goals:

- easy to build those libraries with single command
- output is in same format and configurations
- provide static linked libraries

## Structures ##

```
<xworkspace>
  |-- external
        |-- bin
             |-- x86
             |-- x64
        |-- include
        |-- libs
             |-- boost
                   |-- x86_debug
                   |-- x64_debug
                   |-- x86_release
                   |-- x64_release
             |-- openssl
                   |-- x86_debug
                   |-- x64_debug
                   |-- x86_release
                   |-- x64_release
             |-- ...
        |-- sources
```

### *bin* ###

This folder contains all the executables and DLLs from 3rd-party libraries.

### *include* ###

This folder contains all header files from 3rd-party libraries.

### *libs* ###

This folder contains all the libraries from 3rd-party libraries.

### *sources* ###

This folder contains 3rd-party libraries original source files.

## Libraries ##

- [boost 1.73.0](https://www.boost.org/)
- [openssl 1.1.1g](https://www.openssl.org/)
- [cpprestsdk 2.10.16](https://github.com/microsoft/cpprestsdk)
- [zlib 1.2.11](https://zlib.net/)
- [websocketpp 0.8.2](https://github.com/zaphoyd/websocketpp)
- [brotli 1.0.7](https://github.com/google/brotli)
- [jansson 2.13.1](https://github.com/akheron/jansson)
- [yara 4.0.2](https://virustotal.github.io/yara/)

## HOWTOs ##

### How to build boost ###

- Download latest version boost source code and extract to `"$XWSROOT/external/sources/boost_x_xx_x"`.
- Modify script `"$XWSROOT/external/sources/xws-build-boost.sh"` and set correct version.
- In git-bash, run `"$XWSROOT/external/sources/xws-build-boost.sh"`

### How to build openssl ###

- Download latest version openssl source code and extract to `"$XWSROOT/external/sources/openssl_x_x_x"`.
- Modify script `"$XWSROOT/external/sources/xws-build-openssl.sh"` and set correct version.
- Check `"$XWSROOT/external/sources/xws-build-openssl-cmd.bat"` and make sure `perl.exe` path is correct.
- In git-bash, run `"$XWSROOT/external/sources/xws-build-openssl.sh"`

### How to build zlib ###

- Download latest version zlib source code and extract to `"$XWSROOT/external/sources/zlib-x-x-x"`.
- Modify script `"$XWSROOT/external/sources/xws-build-zlib.sh"` and set correct version.
- In git-bash, run `"$XWSROOT/external/sources/xws-build-zlib.sh"`

### How to build jansson ###

- Download latest version jansson source code and extract to `"$XWSROOT/external/sources/jansson-x-x-x"`.
- In git-bash, run folloing command:

```bash
cd $XWSROOT/external/sources/jansson-x-x-x
mkdir build
cd build
cmake ..
```

- This generate correct MSVC solution/project files. Modify project file for jansson library, and build it.
- Copy header file and final binaries to `"$XWSROOT/external/include/"` and `"$XWSROOT/external/libs/jansson/"`

### How to build yara ###

- Download latest version yara source code and extract to `"$XWSROOT/external/sources/yara-x-x-x"`.
- Copy `"$XWSROOT/external/sources/yara-x-x-x/windows/vs2017"` to `"$XWSROOT/external/sources/yara-x-x-x/windows/vs2019"` (if you want to build with vs2019)
- Open `"$XWSROOT/external/sources/yara-x-x-x/windows/vs2019/yara.sln"` with vs2019 and let it upgrade all projects files.
- Modify project settings to set correct include/lib path (use openssl and jansson in `"$XWSROOT/external"`) and set correct output name.
- Copy header files and final binaries to `"$XWSROOT/external/include/"` and `"$XWSROOT/external/libs/yara/"`
