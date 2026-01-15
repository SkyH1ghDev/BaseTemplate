# Base Template

<sup>Forked from: [Schtekt/My-Ideal-Setup](https://github.com/Schtekt/My-Ideal-Setup)</sup>

This repository's main purpose is to create a stable foundation for larger C++ projects.
The template uses Premake5 as the core, which makes it compatible with Windows, Linux and MacOS.
If you haven't heard of and/or used Premake5, these articles should familiarise you with the tool:
* [What is Premake?](https://premake.github.io/docs/What-Is-Premake)
* [Using Premake](https://premake.github.io/docs/Using-Premake)
* [Your First Script](https://premake.github.io/docs/Your-First-Script)

## Table of contents

* [Prerequisites](#prerequisites)
* [Building the Project](#building-the-project)
* [Working with this Template](#working-with-this-template)

## Prerequisites

* **Premake5** 
    * Pre-compiled binary can be found [here](https://premake.github.io/)
    * Documentation can be found [here](https://premake.github.io/docs/)
    * You may either copy the binary to the working directory of project, or 
        * Add it to PATH (Windows)
        * Add it to /usr/local/bin (Linux / MacOS) <br></br>

* **CMake**
    * Installer can be found [here](https://cmake.org/download)
        * Certain Linux distros use apt / pacman / *Insert other package manager* for their CMake installs.
          If you use one of these, it is up to you to find out how to install CMake on your machine.
    * Documentation can be found [here](https://cmake.org/cmake/help/latest/)
    * The installed binary should be
        * Added to PATH (Windows)
        * Added to /usr/local/bin (Linux / MacOS)




## Building the Project

Written below is a simple step-by-step guide to build the project from source.


1. Generate the required build files using `Premake5 [action]`.

**Note**: Supported build actions can be found [here](https://premake.github.io/docs/Using-Premake).

2. Execute the following command `git submodule update --init --force --recursive`.

### VS Project Files

3. Open the `.sln`-file.

4. Compile the code.

### Makefile

3. Open a terminal and `cd [working directory]/Generated`.

4. Execute the following command: `make`.

### Other Build Systems

As I have not used any other build systems than the ones listed above;
it is up to you to find out how to compile using any of the other build systems.

### Cleaning the Project

In order to clean the project, you will have to execute the following command: `Premake5 clean`.
This is a custom action, however additional info can be retrieved by either reading the `clean.lua`-file in the `./Premake/`-folder or executing `Premake5 --help`.

## Working with this Template

As with any system or framework, there are some practices and a structure that need to be followed in order for it to be effective.
To get an idea of how to work with this template, read the "rules" that are outlined below.

### Application

The `Application`-project is the "main" project. 
The purpose of this project is to be responsible for any code that is generally changed often and specific for your applications purpose / use case.
In terms of a games, the relevant code for this project would be the game itself as it is often changed and tweaked.

### Library

The `Library`-project is what the name entails, a project that is a library.
The purpose of this project is to be responsible for any code that is supposed to be robust and static.
In terms of games, the relevant code for this project would be the physics engine, renderer etc.

### Test

The `Test`-project is a project that builds a separate testing binary.
The purpose of this project is to be responsible for any unit-tests that may be applicable to your use case.
It is important to note that this template is made so that only the `Library`-project can be tested.
This is mainly due to the fact that code suitable for the `Application`-project generally is too volatile for systematic testing.

### External

The `External`-project isn't one singular project, but rather a collection of multiple projects for each individual external library that is to be linked to the `Library`- and/or `Application`-project.
Each respective project has the responsibility of compiling the targeted library into a static library.

#### Git Submodule

To add new external libraries, the suggested method is to use Git Submodules.
The general commands that are useful for this template are:

* `git submodule add -- [repository link] ./External/[library name]`
    * Adds a repository as a submodule. <br></br>
  
* `git rm ./External/[library name] --cached`
    * Removes a submodule. <br></br>

* `git submodule update --init --force --recursive`
    * Clones, updates and initialises the external libraries into their respective directories. 

#### Templates

As every library is different with wildly varying ways of compilation and standards (see: [relevant XKCD](https://xkcd.com/927/)); the way to compile the libraries may need to be customised accordingly.
Below you will find some somewhat generalised templates for different types of libraries.


##### CMake
```lua
    project "[project name]"

        kind "StaticLib"
        location(projectPath)

        targetdir(targetBuildPath .. "/External")
        objdir(objBuildPath .. "/External/%{prj.name}")

        libDirectory = path.getdirectory(_SCRIPT) .. "/%{prj.name}"

        filter "system:windows"
            kind "Utility"
            prebuildcommands{
                "{MKDIR} %{prj.objdir}",
                "cmake -S " .. AddQuotation(libDirectory) .. " -B %{prj.objdir} [CMake options that may be relevant] -DCMAKE_INSTALL_PREFIX=%{prj.targetdir} -DCMAKE_MSVC_RUNTIME_LIBRARY='MultiThreadedDebug'",
                "cmake --build %{prj.objdir} --config %{cfg.buildcfg} --target install",
            }

        filter "system:linux"
            kind "Makefile"
            buildcommands{
                "{MKDIR} %{prj.objdir}",
                "cmake -S " .. AddQuotation(libDirectory) .. " -B %{prj.objdir} [CMake options that may be relevant] -DCMAKE_INSTALL_PREFIX=%{prj.targetdir}",
                "cmake --build %{prj.objdir} --config %{cfg.buildcfg} --target install",
            }
```

* **Note**: Some CMake projects may require additional tinkering and reading in order to compile a library as a static lib.
  If it doesn't work, it may be worthwhile reading the libraries specific CMakeLists.txt file and add options as necessary.

##### Header-Only
```lua

    project "[project name]"
        kind "StaticLib"
        location(projectPath)

        warnings "Off"

        targetdir(targetBuildPath .. "/External/lib")
        objdir(objBuildPath .. "/%{prj.name}")

        parentPath = targetBuildPath .. "/External/include"
        linkPath = targetBuildPath .. "/External/include/%{prj.name}"

        filter "system:windows"
            kind "Utility"
            prebuildcommands{
                "{MKDIR} " .. AddQuotation(parentPath),
                "{LINKDIR} " .. AddQuotation(linkPath) .. " " .. AddQuotation(rootPath .. "/External/stb"),
            }

        filter "system:linux"
            kind "Makefile"
            buildcommands{
                "{MKDIR} " .. AddQuotation(parentPath),
                "{LINKDIR} -f -T " .. AddQuotation(linkPath) .. " " .. AddQuotation(rootPath .. "/External/stb"),
            }
```
