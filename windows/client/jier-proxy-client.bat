@echo off
chcp 65001 >nul
title Jier-proxy-client 服务管理器

setlocal enabledelayedexpansion

REM 获取脚本所在目录
set "WORK_DIR=%~dp0"
cd /d "%WORK_DIR%"

:menu
cls
echo ================================
echo    JIER Proxy Client 服务管理器
echo ================================
echo 当前目录: %WORK_DIR%
echo.

if exist "jier-proxy-client.exe" (
    echo "[✓] jier-proxy-client.exe 存在"
) else (
    echo "[✗] jier-proxy-client.exe 不存在"
)

if exist "jier-proxy-client.toml" (
    echo "[✓] jier-proxy-client.toml 存在"
    set "CONFIG_FILE=jier-proxy-client.toml"
) else if exist "jier-proxy-client.ini" (
    echo "[✓] jier-proxy-client.ini 存在"
    set "CONFIG_FILE=jier-proxy-client.ini"
) else (
    echo "[✗] 配置文件不存在"
)

echo.
echo    "1. 启动 jier-proxy-client 服务"
echo    "2. 停止 jier-proxy-client 服务"
echo    "3. 查看运行状态"
echo    "4. 打开当前目录"
echo    "5. 退出"
echo.

set /p choice=请选择操作 [1-5]: 

if "%choice%"=="1" goto start_jier_proxy_client
if "%choice%"=="2" goto stop_jier_proxy_client
if "%choice%"=="3" goto check_status
if "%choice%"=="4" goto open_folder
if "%choice%"=="5" goto exit_script
echo "无效选择，请按任意键重新选择..."
pause >nul
goto menu

:start_jier_proxy_client
cls
echo "正在启动 jier-proxy-client 服务..."
echo.

REM 检查 jier-proxy-client.exe 是否存在
if not exist "jier-proxy-client.exe" (
    echo "[错误] 未找到 jier-proxy-client.exe"
    echo "请将 jier-proxy-client.exe 放入当前目录"
    echo.
    pause
    goto menu
)

REM 检查配置文件是否存在
if not exist "jier-proxy-client.toml" if not exist "jier-proxy-client.ini" (
    echo "[错误] 未找到配置文件"
    echo "请确保存在 jier-proxy-client.toml 或 jier-proxy-client.ini"
    echo.
    pause
    goto menu
)

REM 检查是否已在运行
tasklist /fi "imagename eq jier-proxy-client.exe" | find /i "jier-proxy-client.exe" >nul
if not errorlevel 1 (
    echo "[警告] jier-proxy-client 已在运行中！"
    echo.
    pause
    goto menu
)

echo "启动命令: jier-proxy-client.exe -c %CONFIG_FILE%"
echo.
echo "注意：关闭此窗口会终止 jier-proxy-client 服务"
echo.

REM 启动 jier-proxy-client
jier-proxy-client.exe -c %CONFIG_FILE%

echo.
echo "jier-proxy-client 进程已退出。"
pause
goto menu

:stop_jier_proxy_client
cls
echo "正在停止 jier-proxy-client 服务..."
taskkill /f /im jier-proxy-client.exe >nul 2>&1

timeout /t 1 /nobreak >nul

tasklist /fi "imagename eq jier-proxy-client.exe" | find /i "jier-proxy-client.exe" >nul
if errorlevel 1 (
    echo "jier-proxy-client 服务已成功停止。"
) else (
    echo "[错误] 停止 jier-proxy-client 服务失败。"
)
echo.
pause
goto menu

:check_status
cls
echo "jier-proxy-client 进程状态："
echo.
tasklist /fi "imagename eq jier-proxy-client.exe"
echo.
pause
goto menu

:open_folder
cls
echo "正在打开当前目录..."
echo %WORK_DIR%
explorer "%WORK_DIR%"
echo 按任意键返回菜单...
pause >nul
goto menu

:exit_script
echo 再见！
exit /b 0