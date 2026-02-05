@echo off
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_281
set MAVEN_HOME=%cd%\apache-maven-3.8.6
set PATH=%MAVEN_HOME%\bin;%PATH%

REM 检查是否存在本地配置文件
echo 检查安全配置...
if not exist "src\main\resources\application-local.properties" (
    echo 警告: 未找到本地配置文件
    echo 请运行 scripts\setup-security.bat 进行安全配置
    echo 或手动创建 src\main\resources\application-local.properties
    pause
    exit /b 1
)

echo 正在启动SimpleServer应用...
echo 使用本地开发配置...
echo 跳过测试以加快启动速度...
mvn clean compile -DskipTests
mvn spring-boot:run -Dspring.profiles.active=local -DskipTests
pause