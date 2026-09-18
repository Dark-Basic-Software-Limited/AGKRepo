@echo off

rem define the %NDK_PATH% environment variable on your system

rem Prefer explicit NDK_PATH if provided, else fall back to ndk-build on PATH (point this to r28c)
if "%NDK_PATH%"=="" (
	set NDKBUILDCMD=ndk-build
) else (
	set NDKBUILDCMD="%NDK_PATH%\ndk-build"
)
call %NDKBUILDCMD% NDK_OUT=../../build/jniObjs NDK_LIBS_OUT=./jniLibs 2> log.txt

pause
