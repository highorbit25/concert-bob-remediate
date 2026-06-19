package com.creditapp.demo.util;

import org.apache.commons.collections.Predicate;

import java.util.Collection;
import java.util.List;

/**
 * Collection Utility Class using Apache Commons Collections
 */
public class CollectionUtils {
    
    /**
     * Check if a collection is empty or null
     */
    public static boolean isEmpty(Collection<?> collection) {
        return org.apache.commons.collections.CollectionUtils.isEmpty(collection);
    }
    
    /**
     * Check if a collection is not empty
     */
    public static boolean isNotEmpty(Collection<?> collection) {
        return org.apache.commons.collections.CollectionUtils.isNotEmpty(collection);
    }
    
    /**
     * Filter a collection based on a predicate
     */
    public static <T> void filterCollection(Collection<T> collection, Predicate predicate) {
        if (collection != null && predicate != null) {
            org.apache.commons.collections.CollectionUtils.filter(collection, predicate);
        }
    }
    
    /**
     * Get the size of a collection safely
     */
    public static int size(Collection<?> collection) {
        return org.apache.commons.collections.CollectionUtils.size(collection);
    }
    
    /**
     * Example of a safe predicate for filtering
     */
    public static class NotNullPredicate implements Predicate {
        @Override
        public boolean evaluate(Object object) {
            return object != null;
        }
    }
}

// Made with Bob