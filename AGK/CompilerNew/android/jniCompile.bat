@echo off

rem Prefer explicit NDK_PATH if provided, else fall back to ndk-build on PATH (point this to r28c)
if "%NDK_PATH%"=="" (
	set NDKBUILDCMD=ndk-build
) else (
	set NDKBUILDCMD="%NDK_PATH%\ndk-build"
)
call %NDKBUILDCMD% -j16 2> log.txt
if not %ERRORLEVEL% equ 0 ( GOTO failed )

:failed

if "%1"=="nopause" goto end
pause
:end

if not %ERRORLEVEL% equ 0 ( EXIT /B 1 )