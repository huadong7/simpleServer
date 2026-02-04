# SimpleServer 脚本工具使用说明

## 📁 脚本目录结构

所有脚本工具都位于 `scripts/` 目录下，按用途分类：

### 🛠️ 开发工具脚本
- `run.bat` / `run.ps1` - 本地快速启动应用
- `build.bat` / `build.sh` - 项目编译和打包
- `test-local.bat` - 本地功能测试

### 📦 部署工具脚本
- `build-deploy-package.bat` - 生成完整部署包
- `cleanup-deploy.bat` - 清理部署目录冗余文件
- `package-deploy.bat` - 包生成脚本

### 🖥️ 服务器脚本
- `deploy-centos.sh` - CentOS服务器完整部署
- `start-simpleServer.sh` - 服务器应用管理
- `health-check.sh` - 健康检查和自动恢复

## 🚀 使用指南

### 本地开发阶段

#### 1. 快速启动应用
```cmd
# Windows CMD
scripts\run.bat

# Windows PowerShell  
scripts\run.ps1
```

#### 2. 项目构建
```cmd
# 编译和打包
scripts\build.bat

# 本地测试
scripts\test-local.bat
```

### 部署准备阶段

#### 1. 生成部署包
```cmd
scripts\build-deploy-package.bat
```
这将自动生成包含所有必要文件的 `deploy/` 目录。

#### 2. 清理部署目录
```cmd
scripts\cleanup-deploy.bat
```
清理构建过程中产生的临时文件，只保留部署必需文件。

### 服务器运维阶段

#### 1. 上传部署文件
将 `deploy/` 目录全部内容上传到服务器的 `/home/simpleServer/` 目录。

#### 2. 服务器操作
```bash
# 设置执行权限
chmod +x start-simpleServer.sh health-check.sh

# 应用管理
./start-simpleServer.sh start    # 启动应用
./start-simpleServer.sh stop     # 停止应用
./start-simpleServer.sh restart  # 重启应用
./start-simpleServer.sh status   # 查看状态
./start-simpleServer.sh health   # 健康检查
./start-simpleServer.sh logs     # 查看日志
```

## ⚙️ 脚本详细说明

### run.bat / run.ps1
**用途**: 本地快速启动开发环境
**使用场景**: 日常开发调试
**特点**: 自动检测环境，一键启动

### build.bat / build.sh
**用途**: 项目编译和打包
**使用场景**: 代码变更后重新构建
**输出**: 生成到 `target/` 目录

### build-deploy-package.bat
**用途**: 生成生产环境部署包
**使用场景**: 准备发布版本
**输出**: 完整的 `deploy/` 目录

### start-simpleServer.sh
**用途**: 服务器应用生命周期管理
**使用场景**: 生产环境运维
**功能**: 启动、停止、重启、状态检查、健康监控

### health-check.sh
**用途**: 应用健康检查和自动恢复
**使用场景**: 生产环境监控
**功能**: 自动检测应用状态，异常时自动重启

## 🔧 配置说明

### 环境变量配置
脚本会自动检测以下环境：
- Java环境 (JAVA_HOME)
- Maven环境 (MAVEN_HOME)
- 端口占用情况

### 自定义配置
可以在脚本中修改以下参数：
- 应用端口
- JVM参数
- 日志路径
- 数据库连接

## 🛡️ 安全注意事项

1. **权限控制**: 生产环境脚本应设置适当的执行权限
2. **敏感信息**: 配置文件中避免硬编码敏感信息
3. **日志保护**: 确保日志文件不包含敏感数据
4. **备份策略**: 重要操作前做好数据备份

## 🐛 故障排除

### 常见问题

1. **脚本无法执行**
   - 检查文件权限
   - 确认脚本路径正确
   - 验证环境变量配置

2. **构建失败**
   - 检查Java和Maven环境
   - 确认pom.xml配置正确
   - 查看详细错误日志

3. **部署失败**
   - 验证服务器环境
   - 检查配置文件
   - 确认网络连接正常

### 日志查看
```bash
# 构建日志
查看 target/ 目录下的日志文件

# 应用日志
查看 /home/simpleServer/application.log

# 启动日志
查看 /home/simpleServer/startup.log
```

---
📌 **提示**: 建议将常用脚本添加到系统PATH中，便于全局调用。