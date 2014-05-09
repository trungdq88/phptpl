@echo off
setlocal EnableDelayedExpansion
set buildPath=%1
if [!buildPath!]==[] (
    echo Please enter path as first argument.
    exit /b
)
for /r %%i in (%buildPath%\*.php) do (
    set filename=%%i
    :: Exclude *.inc.php files
    if not [!filename:~-8!]==[.inc.php] (
        set htmlfilename=!filename:.php=.html!
        echo Build... !htmlfilename!
        php !filename! > !htmlfilename!
    )
)
echo Complete!