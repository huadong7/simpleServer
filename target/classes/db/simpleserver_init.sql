CREATE DATABASE IF NOT EXISTS simpleserver CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE simpleserver;

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