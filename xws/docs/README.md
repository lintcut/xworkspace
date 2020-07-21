# **XWORKSPACE** #
A workspace template by Xiang Ye

## Table of Content

- [1. Introduction](#1-introduction)
    - [1.1 Background](#11-background)
    - [1.2 Purpose](#12-purpose)
    - [1.3 History](#13-history)
- [2. Prerequisites](#2-prerequisites)
    - [2.1 Git](#21-git)
    - [2.2 Bash](#22-bash)
    - [2.3 Tools](#23-tools)
        - [2.3.1 Common Tools](#231-common-tools)
            - [2.3.1.1 Python](#2311-python)
            - [2.3.1.2 Go](#2312-go)
            - [2.3.1.3 Lua](#2313-lua)
        - [2.3.2 Build Tools for Windows](#232-build-tools-for-windows)
            - [Visual Studio](#visual-studio)
            - [Windows SDK](#windows-sdk)
            - [Windows WDK](#windows-wdk)
        - [2.3.3 Build Tools for Mac](#233-build-tools-for-mac)
            - [Xcode](#xcode)
        - [2.3.4 Build Tools for Linux](#234-build-tools-for-linux)
            - [GCC](#gcc)
            - [Clang](#clang)
    - [2.4 System Variables](#24-system-variables)
- [3. Workspace](#3-workspace)
    - [3.1 Layout](#31-layout)
    - [3.2 Init](#32-init)
- [4. Third-Party](#4-thrid-party)
    - [4.1 Boost](#41-boost)
    - [4.2 OpenSSL](#42-openssl)
    - [4.3 Zlib](#43-zlib)
- [5. Development](#5-development)
    - [5.1 Project](#51-project)
        - [5.1.1 Common Settings](#511-common-settings)
        - [5.1.2 Visual Studio Project](#512-visual-studio-project)
        - [5.1.3 Xcode Project](#513-xcode-project)
        - [5.1.4 CMake Project](#514-cmake-project)
    - [5.2 Unit Test](#52-unit-test)
        - [5.2.1 Framework](#521-framework)
        - [5.2.2 Fixture](#522-fixture)
        - [5.2.3 Auto Run](#523-auto-run)
    - [5.3 Snippets](#53-snippets)
- [6. Deploy and Release](#6-deploy-and-release)
- [7. Misc](#7-misc)
    - [7.1 Coding Style](#71-coding-style)

# 1. Introduction

## 1.1 Background

It is always not easy to set up development environment from scratch. And it takes a lot of time to maintain development environment and workspace cross multiple devices and operation systems. So it is worthy to find a way to make it easier.

## 1.2 Purpose

The purpose of XWORKSPACE is to allow user set up and maintain a consistent development environment cross multiple devices and operation systems.

- Easy to setup
- Easy to update
- Consistent
- Automatic

## 1.3 History

N/A

# 2. Prerequisites

## 2.1 Git

Git is required source control software. User should download and install git before initialize XWORKSPACE.

Git should be downloaded from official site [DOWNLOADS](https://git-scm.com/downloads)

**On Windows**

- Git for Windows doesn't contain GNU Make, download it from [HERE](/workspace.settings/data/make-x64.zip) and put it to "C:\Program Files\Git\usr\bin\make.exe"

## 2.2 Bash

For Mac/Linux, system bash is good enough.

For Windows, use the the bash shipped with Git.

See detail instructions [**HERE**](/workspace.settings/docs/BASH.md) to config bash properly.

## 2.3 Tools

### 2.3.1 Common Tools

Common tools are tools used cross platform.

#### 2.3.1.1 Python

Python is required. Currently XWORKSPACE use python 2.7.

See detail instructions [**HERE**](/workspace.settings/docs/PYTHON.md) to download, setup and config python properly.

#### 2.3.1.2 Go

*Optional*

#### 2.3.1.3 Lua

*Optional*

### 2.3.2 Build Tools for Windows

#### Visual Studio

Use Visual Studio on Windows. [DOWNLAOD](https://www.visualstudio.com/downloads/)

#### Windows SDK

- [Windows SDK](https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk)
- [Windows SDK - Archived](https://developer.microsoft.com/en-us/windows/downloads/sdk-archive)

#### Windows WDK

- [Windows WDK](https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk)
- [Windows WDK - Archived](https://docs.microsoft.com/en-us/windows-hardware/drivers/other-wdk-downloads)

### 2.3.3 Build Tools for Mac

#### Xcode

### 2.3.4 Build Tools for Linux

#### GCC

#### Clang

## 2.4 System Variables

### 2.4.1 XWSROOT

**Windows**

Set System Variable "`XWSROOT=<path/to/XWORKSPACE>`"

**Other Platform**

See section ["3. Global Variables"](/workspace.settings/docs/BASH.md#31-xwsroot)

# 3. Workspace

## 3.1 Layout

### 3.1.1 Overveiw

### 3.1.2 workspace.seetings

### 3.1.3 src

## 3.2 Init

## 3.3 Cleanup

# 4. Third-Party

## 4.1 Boost

## 4.2 OpenSSL

## 4.3 Zlib

# 5. Development

## 5.1 Project

### 5.1.1 Common Settings

#### Project Dirs

#### Project Global Virables

#### Project Include Paths

#### Project Lib Paths

### 5.1.2 Visual Studio Project

### 5.1.3 Xcode Project

### 5.1.4 CMake Project

## 5.2 Unit Test

### 5.2.1 Framework

### 5.2.2 Fixture

### 5.2.3 Auto-run

# 6. Deploy and Release

# 7. Misc

