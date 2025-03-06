@echo off
setlocal enabledelayedexpansion
color 3b

:: KolyShell Enhanced Interactive Shell with script loading and help support
echo Welcome to KolyShell! Type your commands below.
echo Type 'exit' to quit the shell.
echo Type 'load [script_name.ks]' to load and execute a KolyScript file.
echo Type 'help' to view the available commands.
echo.

:: Main loop for interactive shell
:LOOP
set "USER_INPUT="
set /p "USER_INPUT=> "

:: Exit condition
if /i "%USER_INPUT%"=="exit" (
    echo Exiting KolyShell...
    exit /b
)

:: Help command
echo %USER_INPUT% | findstr /i "help" >nul && (
    call :SHOW_HELP
    goto LOOP
)

:: Load script command
echo %USER_INPUT% | findstr /i "load" >nul && (
    set "SCRIPT_NAME=%USER_INPUT:load =%"
    if exist "%SCRIPT_NAME%" (
        echo Loading script: %SCRIPT_NAME%
        call :LOAD_SCRIPT "%SCRIPT_NAME%"
    ) else (
        echo Error: Script file not found!
    )
    goto LOOP
)

:: Process other commands (echo, calculate, define, etc.)
call :PROCESS_COMMAND "%USER_INPUT%"
goto LOOP

:: Function to show the help menu
:SHOW_HELP
echo.
echo Available Commands:
echo.
echo help                - Shows this help menu.
echo load [script.ks]     - Loads and executes a KolyScript file (e.g., load script.ks). (MAKE SURE YOU INCLUDE THE ABSOLUTE PATH)
echo exit                - Exits the KolyShell.
echo define [var] [value] - Defines a variable (e.g., define x 10).
echo print [var]         - Prints the value of a variable (e.g., print x).
echo calculate [exp]     - Evaluates a mathematical expression (e.g., calculate 5 + 3).
echo wait [seconds]      - Pauses the script for the specified number of seconds (e.g., wait 5).
echo if [condition] { ... } - Executes a block of code based on a condition.
echo for [var] from [start] to [end] { ... } - Loops a block of code for a range.
echo input [var]         - Prompts the user for input and stores it in a variable.
echo.
echo Example usage:
echo load script.ks      - Load and run the script from a file called 'script.ks'.
echo define x 10         - Defines a variable 'x' with the value 10.
echo print x             - Prints the value of 'x'.
echo wait 2              - Pauses the script for 2 seconds.
echo.
goto :eof

:: Function to load and execute KolyScript from a file
:LOAD_SCRIPT
set "SCRIPT_FILE=%~1"
for /f "delims=" %%A in (%SCRIPT_FILE%) do (
    set "LINE=%%A"
    call :PROCESS_COMMAND "!LINE!"
)
goto :eof

:: Function to process individual commands
:PROCESS_COMMAND
set "COMMAND=%~1"

:: Ignore empty lines and comments
if "%COMMAND%"=="" exit /b
if "%COMMAND:~0,1%"=="#" exit /b

:: echo Command
echo %COMMAND% | findstr /i "echo" >nul && (
    set "SPEECH_TEXT=%COMMAND:echo = %"
    echo !SPEECH_TEXT!
    exit /b
)

:: calculate Command
echo %COMMAND% | findstr /i "calculate" >nul && (
    set "EXPRESSION=%COMMAND:calculate = %"
    call :EVAL_EXPRESSION "!EXPRESSION!"
    exit /b
)

:: define Command
echo %COMMAND% | findstr /i "define" >nul && (
    set "VARIABLE_NAME=%COMMAND:define = %"
    set "VARIABLE_VALUE=%VARIABLE_NAME:* = %"
    set %VARIABLE_NAME%=%VARIABLE_VALUE%
    echo Defined %VARIABLE_NAME% as %VARIABLE_VALUE%
    exit /b
)

:: print Command
echo %COMMAND% | findstr /i "print" >nul && (
    set "VARIABLE=%COMMAND:print = %"
    echo !%VARIABLE!
    exit /b
)

:: wait Command
echo %COMMAND% | findstr /i "wait" >nul && (
    set "WAIT_TIME=%COMMAND:wait = %"
    timeout /t %WAIT_TIME% >nul
    echo Waited for %WAIT_TIME% seconds
    exit /b
)

:: Unknown Command Handling
echo Error: Unknown command - %COMMAND%
exit /b

:EVAL_EXPRESSION
setlocal enabledelayedexpansion
set "EXPRESSION=%~1"
set "RESULT=0"

:: Evaluate the expression (basic math)
for /f "delims=" %%A in ('echo %EXPRESSION%') do set RESULT=%%A

echo Calculation result: !RESULT!
endlocal
exit /b


