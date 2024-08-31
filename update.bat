@echo off
setlocal

:: Define URLs and filenames
set VERSION_URL=https://raw.githubusercontent.com/1Coderexe/MMUpdate/main/version.txt
set UPDATE_URL=https://raw.githubusercontent.com/1Coderexe/MMUpdate/main/update.bat
set CURRENT_VERSION=0.3
set TEMP_FILE=temp_update.bat
set SCRIPT_NAME=self_update.bat
set RESTART_FILE=temp_restart.bat

:: Fetch the latest version from the server
curl -s %VERSION_URL% > current_version.txt

:: Read the latest version
set /p LATEST_VERSION=<current_version.txt

:: Check if an update is needed
if "%CURRENT_VERSION%" neq "%LATEST_VERSION%" (
    echo New version available. Updating...

    :: Download the latest batch file
    curl -s %UPDATE_URL% > %TEMP_FILE%

    :: Create a restart script
    echo @echo off > %RESTART_FILE%
    echo timeout /t 5 /nobreak > nul >> %RESTART_FILE%
    echo start "" "%~f0" >> %RESTART_FILE%
    echo exit >> %RESTART_FILE%

    :: Replace the current batch file with the new one
    move /Y %TEMP_FILE% %SCRIPT_NAME%

    :: Restart the batch file
    echo Restarting the batch file...
    call %RESTART_FILE%
    exit /b
)

:: Proceed with normal operations
echo Running script version %CURRENT_VERSION%...

:: Add your main script logic here

:: Clean up
if exist current_version.txt del current_version.txt
if exist %RESTART_FILE% del %RESTART_FILE%

endlocal
exit
