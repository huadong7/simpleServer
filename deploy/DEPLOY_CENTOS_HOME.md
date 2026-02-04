# SimpleServer CentOS部署指南 (/home/simpleServer目录)

## 部署目录结构

```
/home/simpleServer/
├── simpleServer-1.0.0.jar          # 应用程序jar包
├── application.properties          # 应用配置文件
├── start-simpleServer.sh          # 启动管理脚本
├── application.log                # 应用运行日志
├── startup.log                    # 应用启动日志
└── application.pid                # 应用进程ID文件
```

## 部署前准备

### 1. 服务器环境要求
- CentOS 7.x 或更高版本
- Java 8 或更高版本
- MySQL 5.7 或更高版本

### 2. 安装Java环境
```bash
# 安装OpenJDK
sudo yum install java-1.8.0-openjdk-devel -y

# 验证安装
java -version
```

### 3. 创建应用目录
```bash
sudo mkdir -p /home/simpleServer
sudo chown $USER:$USER /home/simpleServer
```

## 部署步骤

### 1. 上传文件
将以下文件上传到服务器的 `/home/simpleServer` 目录：

```bash
# 在本地执行
scp target/simpleServer-1.0.0.jar user@server:/home/simpleServer/
scp application-prod.properties user@server:/home/simpleServer/application.properties
scp start-simpleServer.sh user@server:/home/simpleServer/
```

### 2. 设置脚本权限
```bash
cd /home/simpleServer
chmod +x start-simpleServer.sh
```

### 3. 配置数据库
编辑 `/home/simpleServer/application.properties` 文件：

```properties
# 修改数据库连接信息
spring.datasource.url=jdbc:mysql://your_mysql_host:3306/simpleserver
spring.datasource.username=your_db_username
spring.datasource.password=your_db_password
```

### 4. 启动应用
```bash
cd /home/simpleServer
./start-simpleServer.sh start
```

## 应用管理命令

```bash
cd /home/simpleServer

# 启动应用
./start-simpleServer.sh start

# 停止应用
./start-simpleServer.sh stop

# 重启应用
./start-simpleServer.sh restart

# 查看应用状态
./start-simpleServer.sh status

# 健康检查
./start-simpleServer.sh health

# 查看日志
./start-simpleServer.sh logs
```

## 日志管理

### 查看实时日志
```bash
cd /home/simpleServer
./start-simpleServer.sh logs
```

### 查看特定时间段日志
```bash
# 查看最近100行
tail -n 100 /home/simpleServer/application.log

# 实时跟踪日志
tail -f /home/simpleServer/application.log

# 搜索特定关键字
grep "ERROR" /home/simpleServer/application.log
```

## 系统服务配置（可选）

创建systemd服务文件：

```bash
sudo vi /etc/systemd/system/simpleServer.service
```

服务配置内容：
```ini
[Unit]
Description=SimpleServer Task Management API
After=network.target mysql.service

[Service]
Type=forking
User=your_user
Group=your_group
WorkingDirectory=/home/simpleServer
PIDFile=/home/simpleServer/application.pid
Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk

ExecStart=/home/simpleServer/start-simpleServer.sh start
ExecStop=/home/simpleServer/start-simpleServer.sh stop
ExecReload=/home/simpleServer/start-simpleServer.sh restart

Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

启用并启动服务：
```bash
sudo systemctl daemon-reload
sudo systemctl enable simpleServer
sudo systemctl start simpleServer
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

### 健康检查脚本
```bash
#!/bin/bash
# health-check.sh

cd /home/simpleServer
./start-simpleServer.sh health

if [ $? -ne 0 ]; then
    echo "$(date): Application health check failed, restarting..."
    ./start-simpleServer.sh restart
fi
```

添加到crontab每5分钟检查一次：
```bash
*/5 * * * * /home/simpleServer/health-check.sh >> /home/simpleServer/health-check.log 2>&1
```

### 日志轮转配置
```bash
sudo vi /etc/logrotate.d/simpleServer
```

配置内容：
```
/home/simpleServer/application.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 644 your_user your_group
    postrotate
        /bin/kill -USR1 `cat /home/simpleServer/application.pid 2>/dev/null` 2>/dev/null || true
    endscript
}
```

## 故障排除

### 常见问题及解决方案

1. **端口被占用**
   ```bash
   # 查找占用端口的进程
   netstat -tlnp | grep :37210
   
   # 终止进程
   kill -9 PID
   ```

2. **数据库连接失败**
   - 检查MySQL服务状态：`systemctl status mysqld`
   - 验证数据库用户权限
   - 确认数据库存在且可访问

3. **内存不足**
   - 调整JVM参数中的-Xms和-Xmx值
   - 检查服务器内存使用情况

4. **启动失败**
   ```bash
   # 查看启动日志
   cat /home/simpleServer/startup.log
   
   # 查看应用日志
   tail -f /home/simpleServer/application.log
   ```

### 性能调优

在 `application.properties` 中添加：
```properties
# 连接池优化
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.minimum-idle=10

# JVM调优（在start-simpleServer.sh中修改JAVA_OPTS）
JAVA_OPTS="-Xms1g -Xmx2g -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
```

## 备份和恢复

### 备份脚本
```bash
#!/bin/bash
# backup.sh

BACKUP_DIR="/home/backups/simpleServer"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# 备份应用文件
tar -czf $BACKUP_DIR/simpleServer_$DATE.tar.gz /home/simpleServer

# 备份数据库
mysqldump -u username -p simpleserver > $BACKUP_DIR/database_$DATE.sql

echo "Backup completed: $BACKUP_DIR/simpleServer_$DATE.tar.gz"
```

## 升级部署

```bash
# 停止当前应用
cd /home/simpleServer
./start-simpleServer.sh stop

# 备份当前版本
cp simpleServer-1.0.0.jar simpleServer-1.0.0.jar.backup.$(date +%Y%m%d)

# 上传新版本
# scp new-version.jar user@server:/home/simpleServer/simpleServer-1.0.0.jar

# 启动应用
./start-simpleServer.sh start
```