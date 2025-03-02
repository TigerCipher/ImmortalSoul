ROOT_PATH = function(path)
    return string.format("%s/%s", _MAIN_SCRIPT_DIR, path)
end

PROJ_DIR = ROOT_PATH "projects"
DEP_DIR  = ROOT_PATH "dependencies"
BIN_DIR  = ROOT_PATH "_build/bin/%{cfg.buildcfg}-%{cfg.platform}"
OBJ_DIR  = ROOT_PATH "_build/obj/%{cfg.buildcfg}-%{cfg.platform}/%{prj.name}"

WORKSPACE_NAME = "ImmortalSoul"
START_PROJECT  = "ImmortalSoul"

print("Executing workspace.lua")
include 'workspace.lua'

function platform_defines()
    print("Setting platform defines")

    -- Raylib stuff
    filter {"configurations:debug or release or profile"}
        defines{"PLATFORM_DESKTOP"}

    filter {"options:graphics=opengl43"}
        defines{"GRAPHICS_API_OPENGL_43"}

    filter {"options:graphics=opengl33"}
        defines{"GRAPHICS_API_OPENGL_33"}

    filter {"options:graphics=opengl21"}
        defines{"GRAPHICS_API_OPENGL_21"}

    filter {"options:graphics=opengl11"}
        defines{"GRAPHICS_API_OPENGL_11"}

    filter {"options:graphics=openges3"}
        defines{"GRAPHICS_API_OPENGL_ES3"}

    filter {"options:graphics=openges2"}
        defines{"GRAPHICS_API_OPENGL_ES2"}

    filter {"system:macosx"}
        disablewarnings {"deprecated-declarations"}

    filter {"system:linux"}
        defines {"_GLFW_X11"}
        defines {"_GNU_SOURCE"}
-- This is necessary, otherwise compilation will fail since
-- there is no CLOCK_MONOTOMIC. raylib claims to have a workaround
-- to compile under c99 without -D_GNU_SOURCE, but it didn't seem
-- to work. raylib's Makefile also adds this flag, probably why it went
-- unnoticed for so long.
-- It compiles under c11 without -D_GNU_SOURCE, because c11 requires
-- to have CLOCK_MONOTOMIC
-- See: https://github.com/raysan5/raylib/issues/2729

    -- end Raylib stuff

    filter {"configurations:debug"}
        defines{"DEBUG"}
    filter {"configurations:release or profile"}
        defines{"NDEBUG"}

    filter "system:windows"
        defines{"_WIN32"}

    filter {"system:macosx"}
        defines{"_OSX"}

    filter {"system:linux"}
        defines{"_LINUX"}

    filter "action:vs*"
        defines{"_WINSOCK_DEPRECATED_NO_WARNINGS", "_CRT_SECURE_NO_WARNINGS"}

    filter{}
end

print("Executing projects.lua")
include 'projects.lua'

for _, path in ipairs(PROJECTS) do
    print("Executing " .. path .. "/premake5.lua")
    include(path .. "/premake5.lua")
end

include "SolutionItems/misc.lua"