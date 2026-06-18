package com.creditapp.demo.actions;

import com.creditapp.demo.model.CreditReport;
import com.creditapp.demo.service.CreditService;
import org.apache.struts2.ActionSupport;

/**
 * Credit Check Action - Handles credit report requests
 */
public class CreditCheckAction extends ActionSupport {
    private static final long serialVersionUID = 1L;
    
    private String ssn;
    private String firstName;
    private String lastName;
    private String dateOfBirth;
    
    private CreditReport creditReport;
    private CreditService creditService;
    
    public CreditCheckAction() {
        this.creditService = new CreditService();
    }
    
    @Override
    public String execute() {
        try {
            // Validate input
            if (ssn == null || ssn.trim().isEmpty()) {
                addActionError("SSN is required");
                return INPUT;
            }
            
            if (firstName == null || firstName.trim().isEmpty()) {
                addActionError("First name is required");
                return INPUT;
            }
            
            if (lastName == null || lastName.trim().isEmpty()) {
                addActionError("Last name is required");
                return INPUT;
            }
            
            // Get credit report
            creditReport = creditService.getCreditReport(ssn, firstName, lastName);
            
            if (creditReport == null) {
                addActionError("No credit report found for the provided information");
                return ERROR;
            }
            
            return SUCCESS;
            
        } catch (Exception e) {
            addActionError("Error retrieving credit report: " + e.getMessage());
            return ERROR;
        }
    }
    
    // Getters and Setters
    public String getSsn() {
        return ssn;
    }
    
    public void setSsn(String ssn) {
        this.ssn = ssn;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getDateOfBirth() {
        return dateOfBirth;
    }
    
    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    
    public CreditReport getCreditReport() {
        return creditReport;
    }
    
    public void setCreditReport(CreditReport creditReport) {
        this.creditReport = creditReport;
    }
    
    public int getCreditScore() {
        return creditReport != null ? creditReport.getCreditScore() : 0;
    }
}

// Made with Bob
