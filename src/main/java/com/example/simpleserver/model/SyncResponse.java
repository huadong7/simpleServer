package com.example.simpleserver.model;

import lombok.Data;

@Data
public class SyncResponse {
    private boolean success;
    private String message;
    private int count;

    public SyncResponse() {
    }

    public SyncResponse(boolean success, String message, int count) {
        this.success = success;
        this.message = message;
        this.count = count;
    }
}