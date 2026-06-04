import axios from 'axios';

/**
 * Fetch weather data using axios with SAFE usage pattern
 * 
 * CVE-2023-45857 Analysis:
 * This code uses axios@1.5.1 which has CVE-2023-45857 (SSRF via protocol-relative URLs).
 * However, this is a FALSE POSITIVE because:
 * 
 * - ✅ SAFE: URL is hardcoded (https://api.openweathermap.org)
 * - ✅ SAFE: User input (city) is passed as query parameter, not in URL
 * - ✅ SAFE: Query parameters are automatically URL-encoded by axios
 * - ✅ SAFE: No way for user to control the base URL or protocol
 * - ❌ NOT VULNERABLE: Cannot exploit SSRF as URL is not user-controlled
 * 
 * Vulnerable pattern would be:
 *   axios.get(userInput)  // ❌ DANGEROUS - user controls entire URL
 *   axios.get(`https://api.com/${userInput}`)  // ❌ DANGEROUS - user in URL path
 * 
 * Safe pattern (what we use):
 *   axios.get('https://hardcoded-url', { params: { q: userInput } })  // ✅ SAFE
 */

/**
 * Get weather data for a city
 * @param {string} city - City name (user input, safely handled)
 * @returns {Promise<Object>} Weather data
 */
export async function getWeather(city) {
  try {
    // SAFE: Hardcoded URL, user input only in query parameters
    const response = await axios.get('https://api.openweathermap.org/data/2.5/weather', {
      params: {
        q: city,  // User input safely passed as query parameter
        appid: 'demo_api_key',  // In production, use process.env.WEATHER_API_KEY
        units: 'metric'
      },
      timeout: 5000  // Good practice: set timeout
    });
    
    return {
      city: response.data.name,
      temperature: response.data.main.temp,
      description: response.data.weather[0].description,
      humidity: response.data.main.humidity,
      windSpeed: response.data.wind.speed
    };
  } catch (error) {
    if (error.response) {
      // API returned error response
      throw new Error(`Weather API error: ${error.response.data.message || error.response.statusText}`);
    } else if (error.request) {
      // Request made but no response
      throw new Error('Weather API is not responding');
    } else {
      // Error setting up request
      throw new Error(`Error fetching weather: ${error.message}`);
    }
  }
}

/**
 * Get weather forecast for multiple cities
 * @param {string[]} cities - Array of city names
 * @returns {Promise<Object[]>} Array of weather data
 */
export async function getWeatherForCities(cities) {
  try {
    // SAFE: Using Promise.all with hardcoded URLs
    const promises = cities.map(city => getWeather(city));
    return await Promise.all(promises);
  } catch (error) {
    throw new Error(`Error fetching weather for cities: ${error.message}`);
  }
}

// Made with Bob
