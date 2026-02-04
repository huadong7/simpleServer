# 设置环境变量
$env:JAVA_HOME = "C:\Program Files\Java\jdk1.8.0_281"
$env:MAVEN_HOME = "$pwd\apache-maven-3.8.6"
$env:PATH = "$env:MAVEN_HOME\bin;$env:PATH"

Write-Host "start SimpleServer..." -ForegroundColor Green
Write-Host "start SimpleServer..." -ForegroundColor Green
Write-Host "start SimpleServer..." -ForegroundColor Green
Write-Host "Skip tests to speed up startup...." -ForegroundColor Yellow
Write-Host "Skip tests to speed up startup...." -ForegroundColor Yellow
Write-Host "Skip tests to speed up startup...." -ForegroundColor Yellow

# 清理并编译项目
mvn clean compile -DskipTests

# 运行应用
mvn spring-boot:run -DskipTests