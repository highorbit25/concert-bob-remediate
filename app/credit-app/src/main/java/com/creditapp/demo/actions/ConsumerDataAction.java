package com.creditapp.demo.actions;

import com.creditapp.demo.model.Consumer;
import com.creditapp.demo.service.ConsumerService;
import com.opensymphony.xwork2.ActionSupport;

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
            
            consumer = consumerService.getConsumer(consumerId);
            
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
