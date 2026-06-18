package com.creditapp.demo.actions;

import com.creditapp.demo.model.Dispute;
import org.apache.struts2.ActionSupport;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Dispute Action - Handles credit report disputes
 */
public class DisputeAction extends ActionSupport {
    private static final long serialVersionUID = 1L;
    
    private String consumerId;
    private String reportId;
    private String disputeType;
    private String description;
    
    private Dispute dispute;
    private List<Dispute> disputes;
    
    public DisputeAction() {
        this.disputes = new ArrayList<>();
    }
    
    /**
     * Create a new dispute
     */
    public String create() {
        try {
            if (consumerId == null || consumerId.trim().isEmpty()) {
                addActionError("Consumer ID is required");
                return INPUT;
            }
            
            if (disputeType == null || disputeType.trim().isEmpty()) {
                addActionError("Dispute type is required");
                return INPUT;
            }
            
            // Create new dispute
            dispute = new Dispute();
            dispute.setDisputeId("DISP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            dispute.setConsumerId(consumerId);
            dispute.setReportId(reportId);
            dispute.setDisputeType(disputeType);
            dispute.setDescription(description);
            dispute.setStatus("Pending");
            
            addActionMessage("Dispute created successfully: " + dispute.getDisputeId());
            
            return SUCCESS;
            
        } catch (Exception e) {
            addActionError("Error creating dispute: " + e.getMessage());
            return ERROR;
        }
    }
    
    /**
     * List disputes for a consumer
     */
    public String list() {
        try {
            if (consumerId == null || consumerId.trim().isEmpty()) {
                addActionError("Consumer ID is required");
                return INPUT;
            }
            
            // Mock dispute list (in real app, would query database)
            disputes = new ArrayList<>();
            Dispute mockDispute = new Dispute("DISP-001", consumerId, "Incorrect Information");
            mockDispute.setDescription("Credit score is incorrect");
            mockDispute.setStatus("Under Review");
            disputes.add(mockDispute);
            
            return SUCCESS;
            
        } catch (Exception e) {
            addActionError("Error listing disputes: " + e.getMessage());
            return ERROR;
        }
    }
    
    @Override
    public String execute() {
        return list();
    }
    
    // Getters and Setters
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
    
    public Dispute getDispute() {
        return dispute;
    }
    
    public void setDispute(Dispute dispute) {
        this.dispute = dispute;
    }
    
    public List<Dispute> getDisputes() {
        return disputes;
    }
    
    public void setDisputes(List<Dispute> disputes) {
        this.disputes = disputes;
    }
}

// Made with Bob
