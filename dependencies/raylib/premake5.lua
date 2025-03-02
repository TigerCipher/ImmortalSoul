raylibDir = DEP_DIR .. "/raylib/raylib"


project "raylib"
    kind          "StaticLib"
    language      "C"
    staticruntime "on"
    systemversion "latest"
    warnings      "extra"
    targetdir     (BIN_DIR)
    objdir        (OBJ_DIR)
    
    platform_defines()

    filter "action:vs*"
        defines{"_WINSOCK_DEPRECATED_NO_WARNINGS", "_CRT_SECURE_NO_WARNINGS"}
        characterset ("Unicode")
        buildoptions { "/Zc:__cplusplus" }
    filter{}

    vpaths
        {
            ["Header Files"] = { raylibDir .. "/src/**.h"},
            ["Source Files/*"] = { raylibDir .. "/src/**.c"},
        }

    files {raylibDir .. "/src/*.h", raylibDir .. "/src/*.c"}

    includedirs {raylibDir .. "/src" }
    includedirs { raylibDir .."/src/external/glfw/include" }

    filter { "system:macosx" }
        files { raylibDir .. "/src/rglfw.c" }
        compileas "Objective-C"

    filter{}