# SimpleServer 项目规范文档

## 项目基本信息

### 项目名称
- **正式名称**: simpleServer
- **包名规范**: com.example.simpleserver
- **数据库名**: simpleserver
- **应用端口**: 37210

### 技术栈
- **框架**: Spring Boot 2.7.0
- **构建工具**: Maven 3.x
- **数据库**: MySQL 5.7
- **ORM框架**: Spring Data JPA
- **Java版本**: Java 8

## 代码规范

### 包结构规范
```
com.example.simpleserver
├── controller/     # 控制器层
├── service/        # 业务逻辑层
├── repository/     # 数据访问层
├── model/          # 实体模型层
├── config/         # 配置类
└── exception/      # 异常处理类
```

### 实体类规范
```java
@Data
@Entity
@Table(name = "table_name")
public class EntityName {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "column_name")
    private String fieldName;
    
    // 显式定义关键setter方法
    public void setId(Long id) {
        this.id = id;
    }
}
```

### API设计规范
- 遵循RESTful规范
- 使用标准HTTP状态码
- 统一响应结构包装
- 接口路径统一前缀：`/api/`

### 数据库规范
- 字段命名采用下划线风格
- 时间字段统一使用`created_at`和`updated_at`
- 布尔类型字段使用`is_xxx`命名
- JSON字段使用`JSON`数据类型

## 部署规范

### 目录结构
```
生产环境部署目录: /home/simpleServer/
├── simpleServer-1.0.0.jar          # 主应用程序
├── application.properties          # 配置文件
├── start-simpleServer.sh          # 启动脚本
├── health-check.sh                # 健康检查脚本
└── 日志文件                        # 自动生成
```

### 构建规范
- 开发时构建输出到`target/`目录
- 部署包生成到`deploy/`目录
- 部署包只包含运行必需文件

### 启动脚本规范
```bash
# 应用管理命令
./start-simpleServer.sh start    # 启动应用
./start-simpleServer.sh stop     # 停止应用
./start-simpleServer.sh restart  # 重启应用
./start-simpleServer.sh status   # 查看状态
./start-simpleServer.sh health   # 健康检查
./start-simpleServer.sh logs     # 查看日志
```

## 配置规范

### application.properties 核心配置
```properties
# 服务器配置
server.port=37210
server.address=0.0.0.0

# 数据库配置
spring.datasource.url=jdbc:mysql://localhost:3306/simpleserver
spring.datasource.username=username
spring.datasource.password=password

# JPA配置
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false

# 日志配置
logging.level.com.example.simpleserver=INFO
logging.file.name=/home/simpleServer/application.log
```

## 开发流程规范

### 标准开发流程
1. 环境检查与准备
2. 项目结构创建
3. 依赖配置与构建
4. 应用启动与验证
5. 问题诊断与修复
6. 数据初始化
7. 功能测试
8. 部署包生成

### 问题处理规范
1. 优先检查端口占用情况
2. 验证数据库连接配置
3. 确认依赖包版本兼容性
4. 检查实体类与数据库字段映射
5. 查看详细错误日志

## 数据库初始化规范

### 建表语句规范
```sql
CREATE TABLE table_name (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    field_name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 数据初始化规范
- 统一生成建表和示例数据脚本
- 确保字段定义完整（包括默认值）
- 命名保持一致性
- 同步更新实体类@Column映射

## 版本管理规范

### 文件版本控制
- pom.xml中维护版本号
- 部署包文件名包含版本信息
- 配置文件按环境区分

### 备份规范
- 部署前备份当前版本
- 配置文件变更前备份
- 数据库定期备份

## 监控与维护规范

### 日志管理
- 应用日志: `/home/simpleServer/application.log`
- 启动日志: `/home/simpleServer/startup.log`
- 定期清理过期日志文件

### 健康检查
- 定期执行健康检查脚本
- 监控应用进程状态
- 自动故障恢复机制

### 性能监控
- 监控内存使用情况
- 监控数据库连接池
- 监控API响应时间

## 安全规范

### 访问控制
- 生产环境关闭调试信息
- 配置合适的CORS策略
- 敏感信息加密存储

### 权限管理
- 应用运行使用专用用户
- 文件权限最小化原则
- 定期审查访问权限

## 故障排除指南

### 常见问题及解决方案

1. **端口被占用**
   ```bash
   netstat -tlnp | grep :37210
   kill -9 PID
   ```

2. **数据库连接失败**
   - 检查MySQL服务状态
   - 验证数据库用户权限
   - 确认数据库存在

3. **启动失败**
   - 查看启动日志
   - 检查Java环境
   - 验证配置文件

4. **内存不足**
   - 调整JVM参数
   - 检查服务器资源
   - 优化应用配置

## 参考文档

- [DEPLOY_CENTOS_HOME.md](DEPLOY_CENTOS_HOME.md) - CentOS部署详细说明
- [DEPLOY_PACKAGE_HOME.md](DEPLOY_PACKAGE_HOME.md) - 部署包使用说明
- [README.md](README.md) - 项目说明文档