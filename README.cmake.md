# SeetaAIP Library
> How to use this SeetaAIP template.

## Configuration

Firstly, Change project name in `Cmakelists.txt`.
It decided your output library name.

> If you only want change library name, but not project name: edit `API_NAME` in `Cmakelists.txt`. 

You can change project name quickly by shell script:
```shell
bash script/rename.sh <PorjectName>
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
- Find `TenniS` failed:

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
    
### For Linux

### For Windows

### For Android

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

Or, just copy compiled libraries into wherever you want.
