# **XWORKSPACE** #
A workspace for Windows developer.

## Why ##

On Windows, it is not easy to manage projects, especially if developers want to have a development environment that has unified settings and is easy to use and expand. I experienced a lot of difficulties in my development life which makes me try to find an easy way to set up a unified development environment and come to this project - **`xworkspace`**.

## What xworkspace does ##

**`xworkspace`** is a development environment for Windows developers. It has the following features:

- Integrating with git-bash.
- Using GNU make to build all projects.
- Providing scripts to build several popular 3rd party libraries.
- Easy to use.
- Easy to expand.
- Consistent on different dev-machines.
- Green install/uninstall.

### Support Projects Type List ###

- [x] Win32 Console Application
- [x] Win32 GUI Application
- [x] Win32 DLL
- [x] ATL/MFC
- [x] Win32 Library
- [x] Windows Kernel Library
- [x] Windows Driver

### Support Toolsets, SDKs, WDKs ###

- Visual Studio 2015
- Visual Studio 2017
- Visual Studio 2019
- Windows Kits 10

### Customization ###

Currently **`xworkspace`** doesn't support other project types like java, universal app, dot Net, or other compilers like llvm or gcc --- it just provides a fundamental framework. 

The good news is, because of powerful **make**, it is not very hard to customize and expand this framework. And it is not very hard to port it to other platforms (Linux/Mac).

Most of the work to customize **`xworkspace`** will be done on make files which are under folder `"$XWSROOT/xws/makefiles"` (You can see how simple it is).

## Quick Start ##

It is really simple to use **`xworkspace`**.

### Step 1: Make sure Git and GNU make are installed ###

The **`xworkspace`** depends on git-bash and GNU make, so first we need to make sure these two are installed.

- Download and install Git from [here](https://git-scm.com/download)
- Download GNU make from [here](http://ftp.gnu.org/gnu/make/) and copy **`make.exe`** to `"C:\Program Files\Git\usr\bin"` (where Git is installed)

### Step 2: Clone this repo to your local ###

There are two options:

- If you only want to use **`xworkspace`** as-is, clone it directly.
- If you plan to customize or expand **`xworkspace`**, fork it first.

After clone this repo (for example, to location `"C:\xworkspace"`), add following lines to bash config file `"~/.bashrc" ("C:\Users\{CurrentUser}\.bashrc")`:

```bash
cd /c/xworkspace/xws/settings
source bashrc_xws.sh
cd $XWSROOT
```

### Step 3: Ready To Go ###

Now you can create your project.

- Start git-bash (**`xworkspace`** will ask you to create a developer certificate if there is no one. Just simply run script `"$XWSROOT/xws/bin/xws-gen-devcert.sh"` to create new dev-cert.)
- Create a new folder for your project (e.g. `"mkdir $XWSROOT/src/MyFirstProject"`)
- Add source file and write code
- Copy `"$XWSROOT/xws/makefiles/Makefile"` to your project folder `"$XWSROOT/src/MyFirstProject/Makefile"` and set correct `"TARGETNAME"` and `"TARGETTYPE"` (These are described in **Makefile**).
    - **console**: Win32 console application
    - **gui**: Win32 GUI application
    - **dll**: Win32 DLL
    - **lib**: Win32 Library
    - **klib**: Windows Kernel Library
    - **kdrv**: Windows Driver
- Go to your project folder (`"cd $XWSROOT/src/MyFirstProject"`) and run one of following commands: `makex86dbg`, `makex86rel`, `makex64dbg`, `makex64rel` (Or command with verbose `makex86dbgv`, `makex86relv`, `makex64dbgv`, `makex64relv`).

## Reference ##

