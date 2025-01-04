@echo off
setlocal

:: Self-elevation code
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)

:: Set script directories
set "SCRIPT_DIR=%~dp0"
set "SRC_DIR=%SCRIPT_DIR%src\"
set "DEFAULT_DEST_DIR=C:\Program Files (x86)\IObit\IObit Uninstaller"

:: Set the paths for the encoded files
set "ENCODED_FILE=%SRC_DIR%encoded.txt"

:: Define color codes for output
set "RESET=[0m"
set "GREEN=[32m"
set "RED=[31m"
set "YELLOW=[33m"
set "BLUE=[34m"

:: Check for administrator rights (redundant check after self-elevation, but kept for safety)
net session >nul 2>&1
if %errorlevel% neq 0 (
    :: If not admin, print a message and exit
    echo %RED%You need to run this script as Administrator. Please right-click the script and choose "Run as Administrator".%RESET%
    pause
    exit /b
)

:: Now running with admin privileges
echo %GREEN%Running with administrative privileges...%RESET%
echo Decoding encoded files...

:: Decode main file
powershell -Command "[System.IO.File]::WriteAllBytes('%TEMP%\decoded_file.txt', [System.Convert]::FromBase64String((Get-Content '%ENCODED_FILE%' -Raw)))"
if %errorlevel% neq 0 (
    echo %RED%Failed to decode file.%RESET%
    pause
    exit /b
)

:: Display ASCII art
chcp 65001 >nul
@echo off
setlocal enabledelayedexpansion

:: Define the path to your ASCII art file
set "ascii_file=%SRC_DIR%\ASCII_art.txt"

:: Define the number of spaces for padding
set "padding=                                            "

:: Loop through each line in the ASCII art file and add spaces
for /f "delims=" %%i in (%ascii_file%) do (
    echo !padding!%%i
)

:: Add blank lines at the bottom for additional space
echo.
echo.
echo.

:: Display title section
echo %BLUE%=============================================%RESET%
echo %YELLOW%          IObit Uninstaller Activator         %RESET%
echo %YELLOW%               Activator Script v1.2          %RESET%
echo %BLUE%=============================================%RESET%
echo.

:: Display warning message about the default installation path
echo %RED%Warning: The default installation path for the software is:%RESET%
echo %YELLOW%%DEFAULT_DEST_DIR%%RESET%
echo %RED%If the software is not installed in this directory, please ensure the path is correct before continuing.%RESET%
echo.

:: Prompt for user input with improved menu
echo %GREEN%[1] Activate%RESET%
echo %BLUE%[2] Check for Updates%RESET%
echo %RED%[3] Exit%RESET%
echo.
set /p choice=%BLUE%Choose an option (1, 2, or 3): %RESET%

:: Handle user choice
if "%choice%"=="1" (
    echo Verifying source file...
    if not exist "%TEMP%\decoded_file.txt" (
        echo %RED%Source file not found. Please verify.%RESET%
        pause
        exit /b
    )
    echo Source file exists.

    echo Verifying destination directory...
    if not exist "%DEFAULT_DEST_DIR%" (
        echo %RED%Destination directory not found. Please verify the path.%RESET%
        pause
        exit /b
    )
    echo Destination directory exists.

    echo %GREEN%Activated%RESET%
    copy "%TEMP%\decoded_file.txt" "%DEFAULT_DEST_DIR%\IObitUninstaler.exe" >nul
    if %errorlevel% neq 0 (
        echo %RED%Failed to copy the file.%RESET%
    )
    pause
) else if "%choice%"=="2" (
    echo %BLUE%Opening GitHub page for updates...%RESET%
    start "" "https://github.com/oop7/IObit.Uninstaller-Activator"
    pause
) else if "%choice%"=="3" (
    echo %RED%Exiting...%RESET%
    pause
    exit
) else (
    echo %RED%Invalid choice. Please run the script again and choose 1, 2, or 3.%RESET%
    pause
)

:: Wait for user to press a key before closing
pause
endlocal