package com.creditapp.demo.actions;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Unit tests for CreditCheckAction
 */
public class CreditCheckActionTest {
    
    private CreditCheckAction action;
    
    @Before
    public void setUp() {
        action = new CreditCheckAction();
    }
    
    @Test
    public void testExecuteWithValidData() {
        action.setSsn("123-45-6789");
        action.setFirstName("John");
        action.setLastName("Doe");
        
        String result = action.execute();
        
        assertEquals("SUCCESS", result);
        assertNotNull(action.getCreditReport());
        assertTrue(action.getCreditScore() > 0);
    }
    
    @Test
    public void testExecuteWithMissingSSN() {
        action.setFirstName("John");
        action.setLastName("Doe");
        
        String result = action.execute();
        
        assertEquals("INPUT", result);
        assertTrue(action.hasActionErrors());
    }
    
    @Test
    public void testExecuteWithMissingFirstName() {
        action.setSsn("123-45-6789");
        action.setLastName("Doe");
        
        String result = action.execute();
        
        assertEquals("INPUT", result);
        assertTrue(action.hasActionErrors());
    }
    
    @Test
    public void testExecuteWithMissingLastName() {
        action.setSsn("123-45-6789");
        action.setFirstName("John");
        
        String result = action.execute();
        
        assertEquals("INPUT", result);
        assertTrue(action.hasActionErrors());
    }
    
    @Test
    public void testGetCreditScore() {
        action.setSsn("123-45-6789");
        action.setFirstName("John");
        action.setLastName("Doe");
        action.execute();
        
        int score = action.getCreditScore();
        assertTrue(score >= 300 && score <= 850);
    }
}

// Made with Bob
