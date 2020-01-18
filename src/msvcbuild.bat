@rem Script to build bestdesk, bestwin with MSVC.
@rem
@rem Either open a "Visual Studio .NET Command Prompt"
@rem (Note that the Express Edition does not contain an x64 compiler)
@rem -or-
@rem Open a "Windows SDK Command Shell" and set the compiler environment:
@rem     setenv /release /x86
@rem   -or-
@rem     setenv /release /x64
@rem
@rem Then cd to this directory and run this script.

@if not defined INCLUDE goto :FAIL

@setlocal
@set LJCOMPILE=cl /nologo /c /O2 /W3 /D_CRT_SECURE_NO_DEPRECATE
@set LJLINK=link /nologo
@set LJMT=mt /nologo
@set LJLIB=lib /nologo /nodefaultlib

@set LUAC=luajit -b
@set LJDLLNAME=lua51.dll
@set LJLIBNAME=bin/lua51.lib

%LUAC% blend2d/blarray.lua blarray.obj
%LUAC% blend2d/blcontext.lua blcontext.obj
%LUAC% blend2d/blend2d_ffi.lua blend2d_ffi.obj
%LUAC% blend2d/blend2d.lua blend2d.obj
%LUAC% blend2d/blerror.lua blerror.obj
%LUAC% blend2d/blpath.lua blpath.obj
%LUAC% blend2d/enum.lua enum.obj
@set BLEND2DLIB= blarray.obj blcontext.obj blend2d_ffi.obj blend2d.obj blerror.obj blpath.obj enum.obj


@rem p5blend core library
%LUAC% luasrc/BLDIBSection.lua BLDIBSection.obj
%LUAC% luasrc/p5_blend2d.lua p5_blend2d.obj
%LUAC% luasrc/p5.lua p5.obj
%LUAC% luasrc/scheduler.lua scheduler.obj
%LUAC% luasrc/win32.lua win32.obj


@set CORELIB= BLDIBSection.obj p5_blend2d.obj p5.obj scheduler.obj win32.obj 




%LJCOMPILE% p5blend.c
@if errorlevel 1 goto :BAD

%LJLINK% /out:p5blend.exe %LJLIBNAME% p5blend.obj %CLIBS% %CORELIB% %BLEND2DLIB%
@if errorlevel 1 goto :BAD
if exist p5blend.exe.manifest^
  %LJMT% -manifest p5blend.exe.manifest -outputresource:p5blend.exe



del *.obj *.manifest
@echo.
@echo === Successfully built best applications for Windows/%LJARCH% ===


goto :END
:BAD
@echo.
@echo *******************************************************
@echo *** Build FAILED -- Please check the error messages ***
@echo *******************************************************
@goto :END
:FAIL
@echo You must open a "Visual Studio .NET Command Prompt" to run this script
:END
