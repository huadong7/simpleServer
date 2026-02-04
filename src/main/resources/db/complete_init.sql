-- 完整初始化脚本（建表+数据）
CREATE DATABASE IF NOT EXISTS simpleserver CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE simpleserver;

-- 创建任务表
CREATE TABLE IF NOT EXISTS tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    time_in_millis BIGINT NOT NULL,
    is_monthly TINYINT(1) DEFAULT 0,
    remind_count INT DEFAULT 0,
    is_done TINYINT(1) DEFAULT 0,
    remarks TEXT,
    image_paths JSON,
    max_retries INT DEFAULT 3,
    retry_interval_hours INT DEFAULT 1,
    repeat_mode INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 插入测试数据
INSERT INTO tasks (name, time_in_millis, is_monthly, remind_count, is_done, remarks, image_paths, max_retries, retry_interval_hours, repeat_mode) VALUES
('购买 groceries', 1707033600000, 0, 2, 0, '记得买牛奶和面包', '["/images/grocery1.jpg", "/images/grocery2.jpg"]', 3, 1, 0),
('完成项目报告', 1707120000000, 0, 1, 0, '季度总结报告', '["/documents/report.docx"]', 2, 2, 0),
('健身锻炼', 1707206400000, 0, 0, 1, '今天的训练已完成', '[]', 3, 1, 1);