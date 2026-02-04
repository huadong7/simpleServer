@echo off
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_281
set MAVEN_HOME=%cd%\apache-maven-3.8.6
set PATH=%MAVEN_HOME%\bin;%PATH%

echo 正在启动SimpleTodo应用...
echo 跳过测试以加快启动速度...
mvn clean compile -DskipTests
mvn spring-boot:run -DskipTests
pause