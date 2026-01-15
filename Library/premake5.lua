project "Library"

    kind "StaticLib"
    location(projectPath)

    targetdir(targetBuildPath .. "/%{prj.name}")
    objdir(objBuildPath .. "/%{prj.name}")
    files {
        "include/**.hpp",
        "src/**.cpp"
    }

    includedirs {
        "include/"
    }