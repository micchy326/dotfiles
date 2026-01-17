@echo off
setlocal
cd /d %~dp0

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ===============================================================
    echo  Error: Administrator privileges are required.
    echo  Please right-click the script and select "Run as administrator".
    echo ===============================================================
    pause
    exit /b 1
)

echo ---------------------------------------------------
echo Installing dotfiles for Windows...
echo Run this script as Administrator if mklink fails.
echo ---------------------------------------------------

:: Function to create file link
call :CreateFileLink "%USERPROFILE%\.vimrc" "%~dp0.vimrc"
call :CreateFileLink "%USERPROFILE%\_vimrc" "%~dp0_vimrc"

call :CreateFileLink "%USERPROFILE%\.tmux.conf" "%~dp0.tmux.conf"
call :CreateFileLink "%USERPROFILE%\.zshrc" "%~dp0.zshrc"
call :CreateFileLink "%USERPROFILE%\.zshenv" "%~dp0.zshenv"
call :CreateFileLink "%USERPROFILE%\.gitconfig" "%~dp0.gitconfig"

:: Function to create directory link
call :CreateDirLink "%USERPROFILE%\.vim" "%~dp0.vim"

:: Create directories
if not exist "%USERPROFILE%\.vimundo" mkdir "%USERPROFILE%\.vimundo"
if not exist "%USERPROFILE%\.vim\backup" mkdir "%USERPROFILE%\.vim\backup"

:: VS Code Settings
set "VSCODE_USER=%APPDATA%\Code\User"
if exist "%VSCODE_USER%" (
    call :CreateFileLink "%VSCODE_USER%\settings.json" "%~dp0settings.json"
    call :CreateFileLink "%VSCODE_USER%\keybindings.json" "%~dp0keybindings.json"
) else (
    echo VS Code User directory not found, skipping VS Code logs.
)

echo ---------------------------------------------------
echo Installation complete.
echo ---------------------------------------------------
pause
exit /b

:CreateFileLink
set "LINK_PATH=%~1"
set "TARGET_PATH=%~2"
if exist "%LINK_PATH%" (
    echo Deleting existing %LINK_PATH%
    del "%LINK_PATH%"
)
echo Linking %LINK_PATH% -^> %TARGET_PATH%
mklink "%LINK_PATH%" "%TARGET_PATH%"
exit /b

:CreateDirLink
set "LINK_PATH=%~1"
set "TARGET_PATH=%~2"
if exist "%LINK_PATH%" (
    echo Removing existing directory %LINK_PATH%
    rmdir "%LINK_PATH%"
)
echo Linking Directory %LINK_PATH% -^> %TARGET_PATH%
mklink /D "%LINK_PATH%" "%TARGET_PATH%"
exit /b
