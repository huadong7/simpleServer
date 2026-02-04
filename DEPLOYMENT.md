# SimpleServer 部署指南

## 本地构建

### Windows环境
```cmd
# 运行打包脚本
build.bat
```

### Linux/Mac环境
```bash
# 给脚本添加执行权限
chmod +x build.sh

# 运行打包脚本
./build.sh
```

构建完成后，会在 `target/` 目录下生成 `simpleServer-1.0.0.jar` 文件。

## CentOS服务器部署

### 1. 准备工作

确保服务器满足以下要求：
- CentOS 7.x 或更高版本
- Java 8 或更高版本
- MySQL 5.7 或更高版本

安装Java（如果没有）：
```bash
# 安装OpenJDK
sudo yum install java-1.8.0-openjdk-devel -y

# 验证安装
java -version
```

### 2. 上传文件

将以下文件上传到服务器同一目录：
- `simpleServer-1.0.0.jar` (从target目录)
- `deploy-centos.sh`

### 3. 部署应用

```bash
# 给部署脚本添加执行权限
chmod +x deploy-centos.sh

# 部署应用
./deploy-centos.sh deploy
```

### 4. 配置数据库

编辑配置文件：
```bash
sudo vi /etc/simpleServer/application-prod.properties
```

修改数据库连接信息：
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/simpleserver?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8
spring.datasource.username=你的用户名
spring.datasource.password=你的密码
```

### 5. 启动应用

```bash
# 启动应用
./deploy-centos.sh start

# 查看状态
./deploy-centos.sh status

# 停止应用
./deploy-centos.sh stop

# 重启应用
./deploy-centos.sh restart
```

## 应用管理

### 日志查看
```bash
# 实时查看应用日志
tail -f /var/log/simpleServer/application.log

# 查看启动日志
tail -f /var/log/simpleServer/startup.log
```

### 系统服务配置（可选）

创建系统服务文件：
```bash
sudo vi /etc/systemd/system/simpleserver.service
```

服务配置内容：
```ini
[Unit]
Description=SimpleServer Task Management API
After=network.target

[Service]
Type=simple
User=your_user
WorkingDirectory=/opt/simpleServer
ExecStart=/usr/bin/java -Xms512m -Xmx1024m -jar /opt/simpleServer/simpleServer-1.0.0.jar --spring.config.location=file:/etc/simpleServer/application-prod.properties
SuccessExitStatus=143
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

启用并启动服务：
```bash
sudo systemctl daemon-reload
sudo systemctl enable simpleserver
sudo systemctl start simpleserver
```

## 防火墙配置

开放应用端口：
```bash
# CentOS 7使用firewalld
sudo firewall-cmd --permanent --add-port=37210/tcp
sudo firewall-cmd --reload

# 或者使用iptables
sudo iptables -A INPUT -p tcp --dport 37210 -j ACCEPT
sudo service iptables save
```

## 监控和维护

### 健康检查
```bash
# 检查应用是否响应
curl -f http://localhost:37210/actuator/health || echo "应用不健康"
```

### 自动重启脚本（可选）
```bash
#!/bin/bash
# health-check.sh

APP_URL="http://localhost:37210/actuator/health"
MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -f $APP_URL > /dev/null 2>&1; then
        echo "应用运行正常"
        exit 0
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        echo "应用无响应，重试 $RETRY_COUNT/$MAX_RETRIES"
        sleep 10
    fi
done

echo "应用持续无响应，尝试重启..."
/opt/simpleServer/deploy-centos.sh restart
```

添加到crontab每5分钟检查一次：
```bash
*/5 * * * * /path/to/health-check.sh >> /var/log/simpleServer/health-check.log 2>&1
```

## 故障排除

### 常见问题

1. **端口被占用**
   ```bash
   # 查找占用端口的进程
   netstat -tlnp | grep :37210
   
   # 终止进程
   kill -9 PID
   ```

2. **数据库连接失败**
   - 检查MySQL服务状态
   - 验证数据库用户权限
   - 确认数据库存在

3. **内存不足**
   - 调整JVM参数中的-Xms和-Xmx值
   - 检查服务器内存使用情况

4. **日志文件过大**
   - 配置日志轮转
   - 定期清理旧日志文件

### 性能调优

```properties
# 在application-prod.properties中添加
# 连接池优化
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.minimum-idle=10

# JVM调优
# 在deploy-centos.sh的JAVA_OPTS中调整
JAVA_OPTS="-Xms1g -Xmx2g -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
```

## 版本升级

```bash
# 停止当前应用
./deploy-centos.sh stop

# 部署新版本（会自动备份旧版本）
./deploy-centos.sh deploy

# 启动应用
./deploy-centos.sh start
```