package com.example.simpleserver.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import javax.persistence.*;
import java.util.Date;

@Data
@Entity
@Table(name = "tasks")
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(name = "time_in_millis")
    private Long timeInMillis;
    
    @Column(name = "is_monthly")
    private Boolean isMonthly = false;
    
    @Column(name = "remind_count")
    private Integer remindCount = 0;
    
    @Column(name = "is_done")
    private Boolean isDone = false;
    
    private String remarks;
    
    @Column(name = "image_paths", columnDefinition = "JSON")
    private String imagePaths; // 存储为JSON字符串
    
    @Column(name = "max_retries")
    private Integer maxRetries = 3;
    
    @Column(name = "retry_interval_hours")
    private Integer retryIntervalHours = 1;
    
    @Column(name = "repeat_mode")
    private Integer repeatMode = 0;
    
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdAt;
    
    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedAt;
    
    @Column(name = "is_delete")
    private Boolean isDelete = false;
    
    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
        updatedAt = new Date();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Date();
    }
    
    // 软删除相关方法
    public void markAsDeleted() {
        this.isDelete = true;
        this.updatedAt = new Date();
    }
    
    public boolean isDeleted() {
        return this.isDelete != null && this.isDelete;
    }
    
    // 显式添加setId方法以解决编译问题
    public void setId(Long id) {
        this.id = id;
    }
    
    // 显式添加getId方法
    public Long getId() {
        return this.id;
    }
}