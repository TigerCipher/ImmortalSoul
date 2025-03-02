project "ImmortalSoul"
    kind          "ConsoleApp"
    language      "C++"
    cppdialect    "C++20"
    staticruntime "on"
    systemversion "latest"
    warnings      "extra"
    targetdir     (BIN_DIR)
    objdir        (OBJ_DIR)

    filter {"system:windows", "configurations:release or profile", "action:gmake*"}
            kind "WindowedApp"
            buildoptions { "-Wl,--subsystem,windows" }

    filter {"system:windows", "configurations:release or profile", "action:vs*"}
            kind "WindowedApp"
            entrypoint "mainCRTStartup"

    filter "action:vs*"
            debugdir "$(SolutionDir)"

    filter {}

    vpaths 
    {
        ["Header Files/*"] = { "include/**.h",  "include/**.hpp", "src/**.h", "src/**.hpp"},
        ["Source Files/*"] = {"src/**.c", "src/**.cpp"},
    }

    files {"src/**.c", "src/**.cpp", "src/**.h", "src/**.hpp", "include/**.h", "include/**.hpp"}

    raylibDir = DEP_DIR .. "/raylib/raylib"

    includedirs {
        "src",
        raylibDir .. "/src",
        raylibDir .. "/src/external",
        raylibDir .. "/src/exernal/glfw/include",
    }

    links {
        "raylib"
    }

    flags { "ShadowedVariables"}
    platform_defines()

    defines {

    }

    filter "action:vs*"
        dependson {"raylib"}
        links {"raylib.lib"}
        characterset ("Unicode")
        buildoptions { "/Zc:__cplusplus" }

    filter "system:windows"
        links {"winmm", "gdi32", "opengl32"}
        libdirs {BIN_DIR}

    filter "system:linux"
        links {"pthread", "m", "dl", "rt", "X11"}

    filter "system:macosx"
        links {"OpenGL.framework", "Cocoa.framework", "IOKit.framework", "CoreFoundation.framework", "CoreAudio.framework", "CoreVideo.framework", "AudioToolbox.framework"}

    filter{}