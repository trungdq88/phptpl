@echo off
setlocal EnableDelayedExpansion

if [%1]==[create] call :Create %*
if [%1]==[build] call :Build %*
goto End

:Build
set projectPath=%2
set configFile=%projectPath%\.tpl

if not exist %configFile% (
    echo %projectPath% is not a PHPTPL project root.
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
exit /b

:Create
set projectPath=%2

:: Validate
if exist %projectPath% (
    echo %projectPath% is not empty
    exit /b
)
if [%projectPath%]==[] (
    echo Please enter project name: "phptpl create project-name"
    exit /b
)

:: Create project structure
echo Creating dirs ^& files...
mkdir %projectPath%
mkdir %projectPath%\src
mkdir %projectPath%\src\img
mkdir %projectPath%\src\css
mkdir %projectPath%\src\js
mkdir %projectPath%\src\font
mkdir %projectPath%\dist

:: Write config file
echo PHP Template Engine 1.0. trungdq88@gmail.com > %projectPath%\.tpl

:: Default index.php
echo ^<^?php >> %projectPath%\src\index.php
echo include_once 'header.inc.php'; >> %projectPath%\src\index.php
echo ^?^> >> %projectPath%\src\index.php
echo Hello world! >> %projectPath%\src\index.php
echo ^<^?php >> %projectPath%\src\index.php
echo include_once 'footer.inc.php'; >> %projectPath%\src\index.php
echo ^?^> >> %projectPath%\src\index.php

:: Default header.inc.php
echo header here > %projectPath%\src\header.inc.php

:: Default footer.inc.php
echo footer here > %projectPath%\src\footer.inc.php

call :Build %*

exit /b

:End
