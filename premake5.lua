require "Premake/clean"
require "Premake/helper"

workspace "Workspace"

    location("Generated")
    cppdialect "C++23"
    warnings "Extra"
    fatalwarnings "All"
    externalwarnings "Off"

    configurations {
        "debug",
        "release"
    }

    architecture "x86_64"
    staticruntime "on"

    filter "configurations:debug"
        runtime "Debug"
        defines { "DEBUG" }
        symbols "On"
        optimize "Off"

    filter "configurations:release"
        runtime "Release"
        defines { "NDEBUG" }
        optimize "On"

    rootPath = path.getdirectory(_SCRIPT)
    projectPath = rootPath .. "/Generated"
    targetBuildPath = rootPath .. "/Build/target"
    objBuildPath = rootPath .. "/Build/obj"

include "External"
include "Library"
include "Application"
include "Test"