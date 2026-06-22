package com.creditapp.demo.integration;

import org.junit.Test;

import javax.servlet.Filter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

import static org.junit.Assert.*;

/**
 * Integration test to validate Struts2 filter configuration.
 * This test catches runtime configuration issues like ClassNotFoundException
 * that occur when upgrading Struts versions where filter class paths change.
 */
public class StrutsFilterIntegrationTest {

    private static final String FILTER_CLASS_NAME =
            "org.apache.struts2.dispatcher.filter.StrutsPrepareAndExecuteFilter";
    private static final String WEB_XML_PATH = "src/main/webapp/WEB-INF/web.xml";

    @Test
    public void testStrutsFilterClassExists() throws Exception {
        try {
            // Validate the upgraded Struts filter class can be loaded and instantiated.
            Class<?> filterClass = Class.forName(FILTER_CLASS_NAME);

            assertTrue("Filter class must implement javax.servlet.Filter",
                    Filter.class.isAssignableFrom(filterClass));

            Filter filter = (Filter) filterClass.getDeclaredConstructor().newInstance();
            assertNotNull("Filter instance should not be null", filter);

            System.out.println("✓ Struts filter class validated: " + FILTER_CLASS_NAME);
        } catch (ClassNotFoundException e) {
            fail("Struts filter class not found: " + FILTER_CLASS_NAME +
                    "\nThis usually means the filter class path changed in the Struts version upgrade.");
        }
    }

    @Test
    public void testWebXmlUsesCurrentStrutsFilterClass() throws Exception {
        String webXml = new String(Files.readAllBytes(Paths.get(WEB_XML_PATH)), StandardCharsets.UTF_8);

        assertTrue("web.xml should reference the upgraded Struts filter class",
                webXml.contains("<filter-class>" + FILTER_CLASS_NAME + "</filter-class>"));
        assertFalse("web.xml should not reference the legacy Struts dispatcher.ng filter class",
                webXml.contains("org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter"));
    }
}

// Made with Bob
