package com.example.simpleserver.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
public class DatabaseConfig {
    // 数据库相关配置可以通过application.properties进行配置
    // 此类可用于添加额外的数据库配置
}