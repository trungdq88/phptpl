@echo off
setlocal EnableDelayedExpansion

set projectPath=%1
set configFile=%projectPath%\.tpl

if not exist %configFile% (
    echo Not a PHPTPL project root.
    exit /b
)
echo --------------------------------------------------------------------------
echo Project path: %projectPath%

set srcPath=%projectPath%\src
set distPath=%projectPath%\dist

:: Clear dist directory
echo --------------------------------------------------------------------------
echo Clear dist directory...
del /Q %distPath%\*
echo Clear dist directory done!

:: Copy all resources to dist
echo --------------------------------------------------------------------------
echo Copying resources...
xcopy %projectPath%\src\* %projectPath%\dist\* /D /E /C /R /I /K /Y 
echo Deleting source files...
del /Q %projectPath%\dist\*.php

:: Build html files
echo --------------------------------------------------------------------------
echo Start build...
for /r %%i in (%srcPath%\*.php) do (
    set filename=%%~nxi
    set fileFullPath=%%i
    :: Exclude *.inc.php files
    if not [!filename:~-8!]==[.inc.php] (
        set htmlfilename=!filename:.php=.html!
        echo Build... !htmlfilename! - %distPath%\!htmlfilename!
        php !fileFullPath! > %distPath%\!htmlfilename!
    )
)
echo --------------------------------------------------------------------------
echo Complete!
echo Dist: %cd%\%distPath%