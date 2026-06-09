package com.creditapp.demo.service;

import com.creditapp.demo.model.CreditReport;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

/**
 * Credit Service - Business logic for credit reports
 */
public class CreditService {
    
    private static final Map<String, CreditReport> mockReports = new HashMap<>();
    private static final Random random = new Random();
    
    static {
        // Initialize with some mock data (147 records to symbolize 147M affected in breach)
        for (int i = 1; i <= 147; i++) {
            String ssn = String.format("%03d-45-%04d", i, 6789 + i);
            CreditReport report = new CreditReport(
                "RPT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase(),
                "CONS-" + String.format("%03d", i),
                generateCreditScore()
            );
            report.setTotalAccounts(random.nextInt(20) + 5);
            report.setOpenAccounts(random.nextInt(10) + 2);
            report.setTotalDebt(random.nextDouble() * 100000);
            report.setPaymentHistory(random.nextInt(30) + 70);
            
            mockReports.put(ssn, report);
        }
    }
    
    /**
     * Get credit report by SSN and name
     */
    public CreditReport getCreditReport(String ssn, String firstName, String lastName) {
        // In a real application, this would query a database
        // For demo purposes, return mock data
        
        CreditReport report = mockReports.get(ssn);
        
        if (report == null) {
            // Generate a new mock report
            report = new CreditReport(
                "RPT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase(),
                "CONS-NEW",
                generateCreditScore()
            );
            report.setTotalAccounts(random.nextInt(20) + 5);
            report.setOpenAccounts(random.nextInt(10) + 2);
            report.setTotalDebt(random.nextDouble() * 100000);
            report.setPaymentHistory(random.nextInt(30) + 70);
        }
        
        return report;
    }
    
    /**
     * Generate a random credit score
     */
    private static int generateCreditScore() {
        // Generate scores in realistic range (300-850)
        return 300 + random.nextInt(551);
    }
    
    /**
     * Get credit report by report ID
     */
    public CreditReport getCreditReportById(String reportId) {
        for (CreditReport report : mockReports.values()) {
            if (report.getReportId().equals(reportId)) {
                return report;
            }
        }
        return null;
    }
}

// Made with Bob
