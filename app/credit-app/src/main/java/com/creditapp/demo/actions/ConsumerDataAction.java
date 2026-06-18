package com.creditapp.demo.actions;

import com.creditapp.demo.model.Consumer;
import com.creditapp.demo.service.ConsumerService;
import org.apache.struts2.ActionSupport;

/**
 * Consumer Data Action - Handles consumer information retrieval and updates
 */
public class ConsumerDataAction extends ActionSupport {
    private static final long serialVersionUID = 1L;
    
    private String consumerId;
    private Consumer consumer;
    private ConsumerService consumerService;
    
    public ConsumerDataAction() {
        this.consumerService = new ConsumerService();
    }
    
    @Override
    public String execute() {
        try {
            if (consumerId == null || consumerId.trim().isEmpty()) {
                addActionError("Consumer ID is required");
                return INPUT;
            }
            
            // Normalize consumer ID - if numeric, convert to CONS-XXX format
            String normalizedId = consumerId.trim();
            if (normalizedId.matches("\\d+")) {
                // Numeric input - convert to CONS-XXX format
                int id = Integer.parseInt(normalizedId);
                normalizedId = "CONS-" + String.format("%03d", id);
            }
            
            consumer = consumerService.getConsumer(normalizedId);
            
            if (consumer == null) {
                addActionError("Consumer not found: " + consumerId);
                return ERROR;
            }
            
            return SUCCESS;
            
        } catch (Exception e) {
            addActionError("Error retrieving consumer data: " + e.getMessage());
            return ERROR;
        }
    }
    
    // Getters and Setters
    public String getConsumerId() {
        return consumerId;
    }
    
    public void setConsumerId(String consumerId) {
        this.consumerId = consumerId;
    }
    
    public Consumer getConsumer() {
        return consumer;
    }
    
    public void setConsumer(Consumer consumer) {
        this.consumer = consumer;
    }
}

// Made with Bob
