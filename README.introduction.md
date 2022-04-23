# SeetaAIP Library
> Introduction SeetaAIP(AI Package)

[![License](https://img.shields.io/badge/license-BSD-blue.svg)](LICENSE)

## Introduction

This is C++ template project, which used to build AIP.

## How to develop

Develop AIP using C++. Read [document](README.cmake.md) for details.

## How to compile

Compile template project using cmake. Read [document](README.cmake.md) for details.

## How to use

View [SeetaAIP](https://gitlab.seetatech.com/SeetaAIoTBase/SeetaAIP) project to download APIs.

Support `C`, `C++`, `python`, `java` and `C#`.

## Setup CI

For multi platform CI usage. You need configure project CI setting and install gitlab-runner with following tags.

- `amd64,docker,linux` for linux and cross compile envriment, including ARM and MinGW.
- `amd64,darwin,shell` for darwin and IOS compilation. Install Xcode, cmake, git and libomp in advance.
- `amd64,cuda,shell,vs2019,windows` for windows apllication. Install VS, cuda, pwsh, cmake and git in advance.

