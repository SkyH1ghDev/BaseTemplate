project "Application"

    kind "ConsoleApp"
    location(projectPath)

    targetdir(targetBuildPath .. "/%{prj.name}")
    debugdir(targetBuildPath .. "/%{prj.name")
    objdir(objBuildPath .. "/%{prj.name}")
    files {
        "src/**.hpp",
        "src/**.cpp"
    }

    libdirs {
        targetBuildPath .. "/Library"
    }
    includedirs {
        "../Library/include",
        targetBuildPath .. "/External/include"
    }

    dependson {
        "Library"
    }

    links {
        AddQuotation("Library")
    }


