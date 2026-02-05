package com.example.simpleserver.repository;

import com.example.simpleserver.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    
    @Query("SELECT t FROM Task t ORDER BY t.updatedAt DESC")
    List<Task> findAllByOrderByUpdatedAtDesc();
    
    List<Task> findByIsDone(Boolean isDone);
    
    List<Task> findByTimeInMillisGreaterThanEqual(Long timeInMillis);
    
    // 软删除相关查询
    @Query("SELECT t FROM Task t WHERE t.isDelete = false ORDER BY t.updatedAt DESC")
    List<Task> findAllActiveByOrderByUpdatedAtDesc();
    
    @Query("SELECT t FROM Task t WHERE t.isDelete = false AND t.isDone = :isDone")
    List<Task> findActiveByIsDone(@Param("isDone") Boolean isDone);
    
    @Query("SELECT t FROM Task t WHERE t.isDelete = false AND t.timeInMillis >= :timeInMillis")
    List<Task> findActiveByTimeInMillisGreaterThanEqual(@Param("timeInMillis") Long timeInMillis);
    
    @Modifying
    @Transactional
    @Query("UPDATE Task t SET t.isDelete = true, t.updatedAt = CURRENT_TIMESTAMP WHERE t.id = :id")
    void softDeleteById(@Param("id") Long id);
}