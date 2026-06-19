package com.creditapp.demo.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Credit Report model
 */
public class CreditReport implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String reportId;
    private String consumerId;
    private int creditScore;
    private String scoreRating;
    private Date reportDate;
    private int totalAccounts;
    private int openAccounts;
    private double totalDebt;
    private int paymentHistory; // percentage
    private String riskLevel;
    
    public CreditReport() {
    }
    
    public CreditReport(String reportId, String consumerId, int creditScore) {
        this.reportId = reportId;
        this.consumerId = consumerId;
        this.creditScore = creditScore;
        this.reportDate = new Date();
        this.scoreRating = calculateRating(creditScore);
        this.riskLevel = calculateRiskLevel(creditScore);
    }
    
    private String calculateRating(int score) {
        if (score >= 800) return "Excellent";
        if (score >= 740) return "Very Good";
        if (score >= 670) return "Good";
        if (score >= 580) return "Fair";
        return "Poor";
    }
    
    private String calculateRiskLevel(int score) {
        if (score >= 740) return "Low";
        if (score >= 670) return "Medium";
        if (score >= 580) return "High";
        return "Very High";
    }
    
    // Getters and Setters
    public String getReportId() {
        return reportId;
    }
    
    public void setReportId(String reportId) {
        this.reportId = reportId;
    }
    
    public String getConsumerId() {
        return consumerId;
    }
    
    public void setConsumerId(String consumerId) {
        this.consumerId = consumerId;
    }
    
    public int getCreditScore() {
        return creditScore;
    }
    
    public void setCreditScore(int creditScore) {
        this.creditScore = creditScore;
        this.scoreRating = calculateRating(creditScore);
        this.riskLevel = calculateRiskLevel(creditScore);
    }
    
    public String getScoreRating() {
        return scoreRating;
    }
    
    public void setScoreRating(String scoreRating) {
        this.scoreRating = scoreRating;
    }
    
    public Date getReportDate() {
        return reportDate;
    }
    
    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }
    
    public int getTotalAccounts() {
        return totalAccounts;
    }
    
    public void setTotalAccounts(int totalAccounts) {
        this.totalAccounts = totalAccounts;
    }
    
    public int getOpenAccounts() {
        return openAccounts;
    }
    
    public void setOpenAccounts(int openAccounts) {
        this.openAccounts = openAccounts;
    }
    
    public double getTotalDebt() {
        return totalDebt;
    }
    
    public void setTotalDebt(double totalDebt) {
        this.totalDebt = totalDebt;
    }
    
    public int getPaymentHistory() {
        return paymentHistory;
    }
    
    public void setPaymentHistory(int paymentHistory) {
        this.paymentHistory = paymentHistory;
    }
    
    public String getRiskLevel() {
        return riskLevel;
    }
    
    public void setRiskLevel(String riskLevel) {
        this.riskLevel = riskLevel;
    }
    
    @Override
    public String toString() {
        return "CreditReport{" +
                "reportId='" + reportId + '\'' +
                ", consumerId='" + consumerId + '\'' +
                ", creditScore=" + creditScore +
                ", scoreRating='" + scoreRating + '\'' +
                ", riskLevel='" + riskLevel + '\'' +
                '}';
    }
}

// Made with Bob
