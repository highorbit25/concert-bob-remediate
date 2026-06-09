package com.creditapp.demo.service;

import com.creditapp.demo.model.Consumer;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

/**
 * Consumer Service - Business logic for consumer data
 */
public class ConsumerService {
    
    private static final Map<String, Consumer> mockConsumers = new HashMap<>();
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    
    static {
        // Initialize with mock consumer data
        try {
            for (int i = 1; i <= 147; i++) {
                Consumer consumer = new Consumer(
                    "CONS-" + String.format("%03d", i),
                    "John" + i,
                    "Doe" + i,
                    String.format("%03d-45-%04d", i, 6789 + i)
                );
                consumer.setDateOfBirth(dateFormat.parse("1980-01-" + String.format("%02d", (i % 28) + 1)));
                consumer.setAddress(i + " Main Street");
                consumer.setCity("Springfield");
                consumer.setState("IL");
                consumer.setZipCode(String.format("620%02d", i % 100));
                consumer.setEmail("john.doe" + i + "@example.com");
                consumer.setPhone("555-" + String.format("%04d", 1000 + i));
                
                mockConsumers.put(consumer.getConsumerId(), consumer);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Get consumer by ID
     */
    public Consumer getConsumer(String consumerId) {
        return mockConsumers.get(consumerId);
    }
    
    /**
     * Get consumer by SSN
     */
    public Consumer getConsumerBySSN(String ssn) {
        for (Consumer consumer : mockConsumers.values()) {
            if (consumer.getSsn().equals(ssn)) {
                return consumer;
            }
        }
        return null;
    }
    
    /**
     * Update consumer information
     */
    public boolean updateConsumer(Consumer consumer) {
        if (consumer == null || consumer.getConsumerId() == null) {
            return false;
        }
        
        mockConsumers.put(consumer.getConsumerId(), consumer);
        return true;
    }
}

// Made with Bob
