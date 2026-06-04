import { useState } from 'react';
import { getWeather } from '../api/weather';
import './Weather.css';

/**
 * Weather Component - Demonstrates axios safe usage (FALSE POSITIVE)
 * 
 * This component uses axios@1.5.1 which has CVE-2023-45857 (SSRF vulnerability).
 * However, this is a FALSE POSITIVE because:
 * 
 * CVE-2023-45857 Analysis:
 * - Vulnerability: SSRF via protocol-relative URLs
 * - Requires: User-controlled URL parameter passed to axios
 * 
 * Our Usage (SAFE):
 * - ✅ URL is hardcoded: 'https://api.openweathermap.org/...'
 * - ✅ User input (city) is passed as query parameter, NOT in URL
 * - ✅ Query parameters are automatically URL-encoded by axios
 * - ✅ No way for user to control the base URL or protocol
 * - ❌ Vulnerable code path is NOT reachable
 * 
 * Bob's intelligent analysis will detect this as FALSE POSITIVE.
 */

function Weather() {
  const [city, setCity] = useState('London');
  const [weather, setWeather] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleFetchWeather = async (e) => {
    e.preventDefault();
    
    if (!city.trim()) {
      setError('Please enter a city name');
      return;
    }

    setLoading(true);
    setError(null);
    setWeather(null);

    try {
      // Using axios with SAFE pattern - hardcoded URL, user input in params
      const data = await getWeather(city);
      setWeather(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const popularCities = ['London', 'New York', 'Tokyo', 'Paris', 'Sydney'];

  return (
    <div className="weather">
      <div className="weather-form">
        <form onSubmit={handleFetchWeather}>
          <div className="form-group">
            <label htmlFor="city">🌍 Enter City Name:</label>
            <input
              type="text"
              id="city"
              value={city}
              onChange={(e) => setCity(e.target.value)}
              placeholder="e.g., London, New York, Tokyo"
              className="form-input"
            />
          </div>
          <button type="submit" className="btn btn-primary" disabled={loading}>
            {loading ? '⏳ Loading...' : '🔍 Get Weather'}
          </button>
        </form>

        <div className="popular-cities">
          <p>Quick select:</p>
          <div className="city-buttons">
            {popularCities.map((popularCity) => (
              <button
                key={popularCity}
                onClick={() => setCity(popularCity)}
                className="btn-city"
                type="button"
              >
                {popularCity}
              </button>
            ))}
          </div>
        </div>
      </div>

      {loading && (
        <div className="weather-loading">
          <div className="spinner"></div>
          <p>Fetching weather data...</p>
        </div>
      )}

      {error && (
        <div className="weather-error">
          <h4>❌ Error</h4>
          <p>{error}</p>
        </div>
      )}

      {weather && !loading && (
        <div className="weather-result">
          <div className="weather-header">
            <h3>🌤️ {weather.city}</h3>
          </div>
          <div className="weather-details">
            <div className="weather-item">
              <span className="weather-label">🌡️ Temperature:</span>
              <span className="weather-value">{weather.temperature}°C</span>
            </div>
            <div className="weather-item">
              <span className="weather-label">☁️ Conditions:</span>
              <span className="weather-value">{weather.description}</span>
            </div>
            <div className="weather-item">
              <span className="weather-label">💧 Humidity:</span>
              <span className="weather-value">{weather.humidity}%</span>
            </div>
            <div className="weather-item">
              <span className="weather-label">💨 Wind Speed:</span>
              <span className="weather-value">{weather.windSpeed} m/s</span>
            </div>
          </div>
        </div>
      )}

      <div className="weather-footer">
        <p className="info-text">
          <strong>Note:</strong> This component uses axios@1.5.1 which has CVE-2023-45857 (SSRF).
          However, Bob's intelligent analysis detects this as a <strong>FALSE POSITIVE</strong> because
          the URL is hardcoded and user input is safely passed as query parameters.
        </p>
      </div>
    </div>
  );
}

export default Weather;

// Made with Bob
