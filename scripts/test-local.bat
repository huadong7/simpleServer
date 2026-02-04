@echo off
REM SimpleServer 本地测试脚本

echo 测试SimpleServer jar包...

java -jar target\simpleServer-1.0.0.jar --spring.profiles.active=test &
set SERVER_PID=%!

echo 服务器启动中，请等待...
timeout /t 15 /nobreak >nul

echo 测试API接口...
curl -f http://localhost:37210/api/tasks || (
    echo API测试失败
    taskkill /PID %SERVER_PID% /F
    exit /b 1
)

echo API测试成功！
taskkill /PID %SERVER_PID% /F
echo 测试完成