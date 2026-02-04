@echo off
REM SimpleServer 开发构建脚本
REM 功能：仅进行项目构建，不生成部署包

setlocal enabledelayedexpansion

echo ========================================
echo SimpleServer 开发构建工具
echo ========================================
echo.

REM 检查Maven环境
echo 1. 检查Maven环境...
if exist "apache-maven-3.8.6\bin\mvn.cmd" (
    set MVN_CMD=apache-maven-3.8.6\bin\mvn.cmd
    echo 使用内置Maven: %MVN_CMD%
) else (
    set MVN_CMD=mvn
    echo 使用系统Maven: %MVN_CMD%
)

echo.
echo 2. 清理项目...
call %MVN_CMD% clean
if %ERRORLEVEL% NEQ 0 (
    echo 错误：清理项目失败
    pause
    exit /b 1
)

echo.
echo 3. 编译和打包项目...
call %MVN_CMD% package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo 错误：编译打包失败
    pause
    exit /b 1
)

REM 检查是否构建成功
if exist "target\simpleServer-1.0.0.jar" (
    echo.
    echo ========================================
    echo 构建成功！
    echo ========================================
    echo 可执行jar包位置: target\simpleServer-1.0.0.jar
    
    REM 显示文件大小
    for %%A in (target\simpleServer-1.0.0.jar) do (
        set size=%%~zA
        set /a sizeMB=size/1024/1024
        echo 文件大小: !sizeMB! MB (!size! bytes)
    )
    
    echo.
    echo 开发测试命令：
    echo 运行应用: java -jar target\simpleServer-1.0.0.jar
    echo 或使用: scripts\run.bat
    echo.
    echo 如需生成完整部署包，请运行: scripts\build-and-package.bat
) else (
    echo.
    echo ========================================
    echo 错误：未找到构建产物
    echo ========================================
    pause
    exit /b 1
)

echo.
pause