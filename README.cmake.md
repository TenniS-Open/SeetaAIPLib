# SeetaAIP Library
> How to use this SeetaAIP template.

## Configuration

Firstly, Change project name in `Cmakelists.txt`.
It decided your output library name.

> If you only want change library name, but not project name: edit `API_NAME` in `Cmakelists.txt`. 

You can change project name quickly by shell script:
```shell
bash script/rename.sh <PorjectName> .
```

There are some option of cmake:

- Common
    + `AIP_TEST` `[ON/OFF]` Default is `OFF`. If compile test binary.
    + `AIP_TENNIS` `[ON/OFF]` Default is `ON`. If link TenniS library.
    + `AIP_OPENCV` `[ON/OFF]` Default is `OFF`. If link OpenCV library.
    
- Advanced
    + `AIP_UPATE` `[ON/OFF]` Default is `ON`. If Auto check `SeetaAIP` API with git.
    + `AIP_TYPE` `[SHARED/STATIC]` Default is `SHARED`.
    
As well, there are some variable can be changed in `CMakeLists.txt`:

- Advanced
    + `AIP_NAME` `String` Default is `${PROJECT_NAME}`. AIP module name, also the output library name.
    + `AIP_ROOT` `String` Default is `.api`. Where to put AIP header `seeta_aip.h`.
    + `AIP_GIT` `String` Default is gitlab project URL.
    + `AIP_TAG` `String` Default is `""`. Empty for default branch. Set for using specific tag or branch.
    
Notice: If `find_package` failed on `OpenCV` or `TenniS`:

- Find `OpenCV` failed: Baidu it!
- Find `TenniS` failed: Define `TenniS_HOME` or edit it in GUI, which telling where the library root.
The `TenniS_HOME` must contain `include` and `lib`.

Finally, there cmake option can be used:

- Original CMake
    + `CMAKE_INSTALL_PREFIX`: Set install path.
    + `CMAKE_BUILD_TYPE`: `[Release|Debug]`
    
## Develop library

Now, all the options are set properly.

Write you own AIP code in `src/lib.cpp`.
Finish the class `ThisPackage`, and change `ThisAIPHeader` and `ThisAIP` properly.
All the SeetaAIP development will be done.

If you need build test executable binary, turn the `AIP_TEST` ON.
Write test code in `test/test.cpp` or create other test file in `test`.
Build and run `test_<AIP_NAME>`.

## Generate project and compile

This part to tell how to compile library with this cmake template.
    
> First of cmake. The given example is base setting of cmake.
> In your own project, parameter could be different by there way.
    
### For Mac
```
mkdir build
cd build
cmake .. -DAIP_TENNIS=ON -DCMAKE_INSTALL_PREFIX=<path>
make -j16
make install
```
    
### For Linux
```
mkdir build
cd build
cmake .. -DAIP_TENNIS=ON -DCMAKE_INSTALL_PREFIX=<path>
make -j16
make install
```

### For Windows

Notice that, windows default compiler is MSVC.
If you want other compiler, use `cmake -G <Generator>`.
Most useful generators are:

| Generator | Mark | How to compile |
| :---: | :---: | :---: |
| Visual Studio 14 2015 [arch] | Optional [arch] can be "Win64" or "ARM" | Open *.sln or use devenv.com |
| NMake Makefiles | This generator on work in MSVC command line tools. | nmake |
| NMake Makefiles JOM | This generator on work in MSVC command line tools, AND Qt executable jom. | jom |
| MSYS Makefiles | Use MSYS make to make. | make |
| MinGW Makefiles | Use mingw32-make to make. | mingw32-make |

Notice that, the default generator is the highest version MSVC installed in you computer.

#### With GUI
Open `cmake-gui` in start menu.
Then you can find out how to use it.
If choose `Visual Studio` generators, open `sln` to compile library with GUI.
If choose other generators, compile library by generator's given way.

#### With CMD
First, setup environment according to used generator.

- `Visual Studio 14 2015`: No need to set ENV, cmake will auto check MSVC.
- `NMake Makefiles [JOM]`: There are two methods to setup environment:
    + Click `Visual Studio Command Tools` in start menu, use popup shell.
    + Use command
        ```
      call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" [platform]
        ```
      Optional [platform] can be `amd64`, `x86` or `arm`.
- `MSYS Makefiles` or `MinGW Makefiles`: Use `MSYS` or `MinGW` command tools, baidu `MSYS`、`MinGW` for more information.
- Other generators: baidu them.

Notice: `VS140COMNTOOLS` is `environment variable` created by MSVC installation.
`VS140COMNTOOLS` means `VS2015`.

Then, generate project file by cmake.
```
# setup MSVC command environment if need,
# witch is used for decide witch MSCV compiler to use.

mkdir build
cd build
cmake .. -DAIP_TENNIS=ON -DCMAKE_INSTALL_PREFIX=<path> -G <Generator>
```

Well, with different generators, there are different ways:

- `Visual Studio 14 2015`: Commonly, open the generated `sln` project file, and compile with GUI. Or use command:
    ```
  "%VS140COMNTOOLS%..\IDE\devenv.com" <PROJECT_NAME>.sln /Build "Release|x64" /Project <AIP_NAME>_LIB
    ```
  Typically, `PORJECT_NAME` and `AIP_NAME` is configured by using cmake.
  `Release|x64` should be build type and platform.
  Build type can be `Debug` or `Release`; Platform can be `x64`, `Win32` or `ARM`.
  Finally, use following command to install libraries. 
    ```
  "%VS140COMNTOOLS%..\IDE\devenv.com" <PROJECT_NAME>.sln /Build "Release|x64" /Project INSTALL
    ```
- `NMake Makefiles`: Command `nmake` with setup environment.
- `NMake Makefiles JOM`: Command `jom` with setup environment, and jom must can be found.
- `MSYS Makefiles` or `MinGW Makefiles`: Command `make` or `mingw32-make` in `MSYS` or `MinGW` environment.
- Other generators: baidu them as well.

### For Android

Well `NDK` is need by anyway. View the website for more information.

`NDK` can be download manually, or by the way they like. 

#### With host Linux

#### With host Windows

### For IOS

## Install

The compile binary library will put in `bin`.

Make sure you've set `CMAKE_INSTALL_PREFIX` to the path you want.
Then run
```
make install
```
to install library.
Or, use specific install command described in `Generate project and compile` part.

Or... just copy compiled libraries into wherever you want.