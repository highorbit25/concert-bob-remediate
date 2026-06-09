package com.creditapp.demo.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Consumer model representing a credit report consumer
 */
public class Consumer implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String consumerId;
    private String firstName;
    private String lastName;
    private String ssn;
    private Date dateOfBirth;
    private String address;
    private String city;
    private String state;
    private String zipCode;
    private String email;
    private String phone;
    
    public Consumer() {
    }
    
    public Consumer(String consumerId, String firstName, String lastName, String ssn) {
        this.consumerId = consumerId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.ssn = ssn;
    }
    
    // Getters and Setters
    public String getConsumerId() {
        return consumerId;
    }
    
    public void setConsumerId(String consumerId) {
        this.consumerId = consumerId;
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
    
    public String getSsn() {
        return ssn;
    }
    
    public void setSsn(String ssn) {
        this.ssn = ssn;
    }
    
    public Date getDateOfBirth() {
        return dateOfBirth;
    }
    
    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getState() {
        return state;
    }
    
    public void setState(String state) {
        this.state = state;
    }
    
    public String getZipCode() {
        return zipCode;
    }
    
    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    @Override
    public String toString() {
        return "Consumer{" +
                "consumerId='" + consumerId + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", ssn='" + maskSsn() + '\'' +
                '}';
    }
    
    private String maskSsn() {
        if (ssn != null && ssn.length() >= 4) {
            return "***-**-" + ssn.substring(ssn.length() - 4);
        }
        return "***-**-****";
    }
}

// Made with Bob
