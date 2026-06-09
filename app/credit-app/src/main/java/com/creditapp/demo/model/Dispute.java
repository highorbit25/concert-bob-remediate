package com.creditapp.demo.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Dispute model for credit report disputes
 */
public class Dispute implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String disputeId;
    private String consumerId;
    private String reportId;
    private String disputeType;
    private String description;
    private String status;
    private Date createdDate;
    private Date resolvedDate;
    private String resolution;
    
    public Dispute() {
        this.createdDate = new Date();
        this.status = "Pending";
    }
    
    public Dispute(String disputeId, String consumerId, String disputeType) {
        this();
        this.disputeId = disputeId;
        this.consumerId = consumerId;
        this.disputeType = disputeType;
    }
    
    // Getters and Setters
    public String getDisputeId() {
        return disputeId;
    }
    
    public void setDisputeId(String disputeId) {
        this.disputeId = disputeId;
    }
    
    public String getConsumerId() {
        return consumerId;
    }
    
    public void setConsumerId(String consumerId) {
        this.consumerId = consumerId;
    }
    
    public String getReportId() {
        return reportId;
    }
    
    public void setReportId(String reportId) {
        this.reportId = reportId;
    }
    
    public String getDisputeType() {
        return disputeType;
    }
    
    public void setDisputeType(String disputeType) {
        this.disputeType = disputeType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
    
    public Date getResolvedDate() {
        return resolvedDate;
    }
    
    public void setResolvedDate(Date resolvedDate) {
        this.resolvedDate = resolvedDate;
    }
    
    public String getResolution() {
        return resolution;
    }
    
    public void setResolution(String resolution) {
        this.resolution = resolution;
    }
    
    @Override
    public String toString() {
        return "Dispute{" +
                "disputeId='" + disputeId + '\'' +
                ", consumerId='" + consumerId + '\'' +
                ", disputeType='" + disputeType + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}

// Made with Bob
