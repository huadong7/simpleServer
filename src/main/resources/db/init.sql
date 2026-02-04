-- 创建数据库
CREATE DATABASE IF NOT EXISTS simpleserver CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE simpleserver;

-- 创建任务表
CREATE TABLE IF NOT EXISTS tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL COMMENT '任务名称',
    timeInMillis BIGINT NOT NULL COMMENT '任务时间戳(毫秒)',
    isMonthly TINYINT(1) DEFAULT 0 COMMENT '是否每月重复(已废弃)',
    remindCount INT DEFAULT 0 COMMENT '提醒次数',
    isDone TINYINT(1) DEFAULT 0 COMMENT '是否完成',
    remarks TEXT COMMENT '备注信息',
    imagePaths JSON COMMENT '图片路径数组',
    maxRetries INT DEFAULT 3 COMMENT '最大重试次数',
    retryIntervalHours INT DEFAULT 1 COMMENT '重试间隔小时数',
    repeatMode INT DEFAULT 0 COMMENT '重复模式: 0-不重复, 1-每日, 2-每周, 3-每月',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    INDEX idx_updated_at (updated_at),
    INDEX idx_is_done (isDone),
    INDEX idx_time_in_millis (timeInMillis)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务表';