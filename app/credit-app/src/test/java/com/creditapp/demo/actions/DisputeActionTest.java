package com.creditapp.demo.actions;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Test suite for DisputeAction
 * Tests dispute filing functionality and JSP view rendering
 */
public class DisputeActionTest {
    
    private DisputeAction action;
    
    @Before
    public void setUp() {
        action = new DisputeAction();
    }
    
    /**
     * Test 1: Dispute list page loads successfully
     * Verifies that the dispute list is returned for default execute
     */
    @Test
    public void testDisputeListDisplay() {
        action.setConsumerId("1");
        String result = action.execute();
        assertEquals("success", result);
        assertNotNull(action.getDisputes());
    }
    
    /**
     * Test 2: Successful dispute creation
     * Verifies that a valid dispute submission returns success
     */
    @Test
    public void testDisputeCreationSuccess() {
        action.setConsumerId("1");
        action.setDisputeType("incorrect_balance");
        action.setDescription("The balance shown is incorrect. It should be $500 less.");
        action.setReportId("RPT-001");
        
        String result = action.create();
        
        assertEquals("success", result);
        assertNotNull(action.getDispute());
        assertNotNull(action.getDispute().getDisputeId());
        assertTrue(action.getDispute().getDisputeId().startsWith("DISP-"));
        assertEquals("1", action.getDispute().getConsumerId());
        assertEquals("incorrect_balance", action.getDispute().getDisputeType());
        assertEquals("Pending", action.getDispute().getStatus());
    }
    
    /**
     * Test 3: Dispute creation with missing consumer ID
     * Verifies that missing consumer ID returns input form
     */
    @Test
    public void testDisputeCreationMissingConsumerId() {
        action.setConsumerId(null);
        action.setDisputeType("incorrect_balance");
        action.setDescription("Test description");
        
        String result = action.create();
        
        assertEquals("input", result);
        assertTrue(action.hasActionErrors());
    }
    
    /**
     * Test 4: Dispute creation with empty consumer ID
     * Verifies that empty consumer ID returns input form
     */
    @Test
    public void testDisputeCreationEmptyConsumerId() {
        action.setConsumerId("");
        action.setDisputeType("incorrect_balance");
        action.setDescription("Test description");
        
        String result = action.create();
        
        assertEquals("input", result);
        assertTrue(action.hasActionErrors());
    }
    
    /**
     * Test 5: Dispute creation with missing dispute type
     * Verifies that missing dispute type returns input form
     */
    @Test
    public void testDisputeCreationMissingDisputeType() {
        action.setConsumerId("1");
        action.setDisputeType(null);
        action.setDescription("Test description");
        
        String result = action.create();
        
        assertEquals("input", result);
        assertTrue(action.hasActionErrors());
    }
    
    /**
     * Test 6: Dispute creation with empty dispute type
     * Verifies that empty dispute type returns input form
     */
    @Test
    public void testDisputeCreationEmptyDisputeType() {
        action.setConsumerId("1");
        action.setDisputeType("");
        action.setDescription("Test description");
        
        String result = action.create();
        
        assertEquals("input", result);
        assertTrue(action.hasActionErrors());
    }
    
    /**
     * Test 7: Dispute ID generation is unique
     * Verifies that each dispute gets a unique ID
     */
    @Test
    public void testDisputeIdGeneration() {
        action.setConsumerId("1");
        action.setDisputeType("incorrect_balance");
        action.setDescription("Test description");
        
        action.create();
        String firstId = action.getDispute().getDisputeId();
        
        // Create new action for second dispute
        DisputeAction action2 = new DisputeAction();
        action2.setConsumerId("2");
        action2.setDisputeType("account_not_mine");
        action2.setDescription("This account doesn't belong to me");
        
        action2.create();
        String secondId = action2.getDispute().getDisputeId();
        
        assertNotEquals(firstId, secondId);
        assertTrue(firstId.startsWith("DISP-"));
        assertTrue(secondId.startsWith("DISP-"));
    }
    
    /**
     * Test 8: Dispute list with valid consumer ID
     * Verifies that dispute list returns success with mock data
     */
    @Test
    public void testDisputeListSuccess() {
        action.setConsumerId("1");
        
        String result = action.list();
        
        assertEquals("success", result);
        assertNotNull(action.getDisputes());
        assertFalse(action.getDisputes().isEmpty());
        assertEquals(1, action.getDisputes().size());
        assertEquals("DISP-001", action.getDisputes().get(0).getDisputeId());
    }
    
    /**
     * Test 9: Dispute list with missing consumer ID
     * Verifies that missing consumer ID returns input form
     */
    @Test
    public void testDisputeListMissingConsumerId() {
        action.setConsumerId(null);
        
        String result = action.list();
        
        assertEquals("input", result);
        assertTrue(action.hasActionErrors());
    }
    
    /**
     * Test 10: Dispute creation with optional report ID
     * Verifies that report ID is optional and stored when provided
     */
    @Test
    public void testDisputeCreationWithReportId() {
        action.setConsumerId("1");
        action.setDisputeType("incorrect_balance");
        action.setReportId("RPT-123456");
        action.setDescription("Test description");
        
        String result = action.create();
        
        assertEquals("success", result);
        assertEquals("RPT-123456", action.getDispute().getReportId());
    }
    
    /**
     * Test 11: Dispute creation without report ID
     * Verifies that report ID is optional
     */
    @Test
    public void testDisputeCreationWithoutReportId() {
        action.setConsumerId("1");
        action.setDisputeType("incorrect_balance");
        action.setDescription("Test description");
        
        String result = action.create();
        
        assertEquals("success", result);
        assertNull(action.getDispute().getReportId());
    }
    
    /**
     * Test 12: Dispute creation with description
     * Verifies that description is stored correctly
     */
    @Test
    public void testDisputeCreationWithDescription() {
        String testDescription = "This is a detailed description of the dispute issue.";
        action.setConsumerId("1");
        action.setDisputeType("incorrect_balance");
        action.setDescription(testDescription);
        
        String result = action.create();
        
        assertEquals("success", result);
        assertEquals(testDescription, action.getDispute().getDescription());
    }
    
    /**
     * Test 13: Multiple dispute types are accepted
     * Verifies that different dispute types return success
     */
    @Test
    public void testMultipleDisputeTypes() {
        String[] disputeTypes = {
            "incorrect_balance",
            "account_not_mine",
            "incorrect_status",
            "duplicate",
            "outdated"
        };
        
        for (String type : disputeTypes) {
            DisputeAction testAction = new DisputeAction();
            testAction.setConsumerId("1");
            testAction.setDisputeType(type);
            testAction.setDescription("Test description for " + type);
            
            String result = testAction.create();
            assertEquals("Dispute type " + type + " should succeed", "success", result);
            assertEquals(type, testAction.getDispute().getDisputeType());
        }
    }
    
    /**
     * Test 14: Dispute status is set to Pending on creation
     * Verifies that new disputes have Pending status
     */
    @Test
    public void testDisputeStatusPending() {
        action.setConsumerId("1");
        action.setDisputeType("incorrect_balance");
        action.setDescription("Test description");
        
        String result = action.create();
        
        assertEquals("success", result);
        assertEquals("Pending", action.getDispute().getStatus());
    }
    
    /**
     * Test 15: Action messages are added on successful creation
     * Verifies that success message is added
     */
    @Test
    public void testDisputeCreationSuccessMessage() {
        action.setConsumerId("1");
        action.setDisputeType("incorrect_balance");
        action.setDescription("Test description");
        
        String result = action.create();
        
        assertEquals("success", result);
        assertTrue(action.hasActionMessages());
        assertFalse(action.getActionMessages().isEmpty());
    }
}

// Made with Bob
