import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import Weather from '../components/Weather';
import * as weatherApi from '../api/weather';

/**
 * Weather Component Tests
 *
 * Tests the Weather component functionality using axios for API calls.
 *
 * These tests verify:
 * - Component renders correctly
 * - Form submission and validation work
 * - Weather data fetching and display function correctly
 * - Error handling works properly
 * - User interactions (input, buttons, form submission)
 *
 * Note: Security analysis (CVE-2023-45857 FALSE POSITIVE detection) is handled
 * by Bob's intelligent code analysis, not by unit tests. These tests focus on
 * functional correctness.
 */

// Mock the weather API
vi.mock('../api/weather');

// Mock weather data
const mockWeatherData = {
  city: 'London',
  temperature: 15.5,
  description: 'partly cloudy',
  humidity: 72,
  windSpeed: 4.5
};

describe('Weather Component', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('Initial Render', () => {
    it('should render the weather form', () => {
      render(<Weather />);

      expect(screen.getByLabelText('🌍 Enter City Name:')).toBeInTheDocument();
      expect(screen.getByPlaceholderText('e.g., London, New York, Tokyo')).toBeInTheDocument();
      expect(screen.getByText('🔍 Get Weather')).toBeInTheDocument();
    });

    it('should have default city value of London', () => {
      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      expect(input).toHaveValue('London');
    });

    it('should display popular city quick select buttons', () => {
      render(<Weather />);

      expect(screen.getByText('Quick select:')).toBeInTheDocument();
      expect(screen.getByRole('button', { name: 'London' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: 'New York' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: 'Tokyo' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: 'Paris' })).toBeInTheDocument();
      expect(screen.getByRole('button', { name: 'Sydney' })).toBeInTheDocument();
    });

    it('should display note about axios CVE and false positive', () => {
      render(<Weather />);

      expect(screen.getByText(/axios@1.5.1 which has CVE-2023-45857/)).toBeInTheDocument();
      expect(screen.getByText(/FALSE POSITIVE/)).toBeInTheDocument();
      expect(screen.getByText(/URL is hardcoded/)).toBeInTheDocument();
    });
  });

  describe('Form Interaction', () => {
    it('should update city input when user types', async () => {
      const user = userEvent.setup();
      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      
      await user.clear(input);
      await user.type(input, 'Paris');

      expect(input).toHaveValue('Paris');
    });

    it('should update city when quick select button is clicked', async () => {
      const user = userEvent.setup();
      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      const tokyoButton = screen.getByRole('button', { name: 'Tokyo' });

      await user.click(tokyoButton);

      expect(input).toHaveValue('Tokyo');
    });

    it('should show error when submitting empty city', async () => {
      const user = userEvent.setup();
      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      const submitButton = screen.getByText('🔍 Get Weather');

      await user.clear(input);
      await user.click(submitButton);

      await waitFor(() => {
        expect(screen.getByText('Please enter a city name')).toBeInTheDocument();
      });
    });

    it('should show error when submitting whitespace-only city', async () => {
      const user = userEvent.setup();
      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      const submitButton = screen.getByText('🔍 Get Weather');

      await user.clear(input);
      await user.type(input, '   ');
      await user.click(submitButton);

      await waitFor(() => {
        expect(screen.getByText('Please enter a city name')).toBeInTheDocument();
      });
    });
  });

  describe('Loading State', () => {
    it('should show loading state while fetching weather', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockImplementation(() => new Promise(() => {}));

      render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      await waitFor(() => {
        expect(screen.getByText('Fetching weather data...')).toBeInTheDocument();
      });

      expect(screen.getByText('⏳ Loading...')).toBeInTheDocument();
    });

    it('should disable submit button while loading', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockImplementation(() => new Promise(() => {}));

      render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      await waitFor(() => {
        expect(screen.getByText('⏳ Loading...')).toBeDisabled();
      });
    });

    it('should have correct loading state structure', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockImplementation(() => new Promise(() => {}));

      const { container } = render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      await waitFor(() => {
        expect(container.querySelector('.weather-loading')).toBeInTheDocument();
      });

      const loadingDiv = container.querySelector('.weather-loading');
      expect(loadingDiv.querySelector('.spinner')).toBeInTheDocument();
    });
  });

  describe('Success State', () => {
    it('should display weather data after successful fetch', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockResolvedValue(mockWeatherData);

      render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      await waitFor(() => {
        expect(screen.getByText('🌤️ London')).toBeInTheDocument();
      });

      expect(screen.getByText('15.5°C')).toBeInTheDocument();
      expect(screen.getByText('partly cloudy')).toBeInTheDocument();
      expect(screen.getByText('72%')).toBeInTheDocument();
      expect(screen.getByText('4.5 m/s')).toBeInTheDocument();
    });

    it('should display weather labels correctly', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockResolvedValue(mockWeatherData);

      render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      await waitFor(() => {
        expect(screen.getByText('🌡️ Temperature:')).toBeInTheDocument();
      });

      expect(screen.getByText('🌡️ Temperature:')).toBeInTheDocument();
      expect(screen.getByText('☁️ Conditions:')).toBeInTheDocument();
      expect(screen.getByText('💧 Humidity:')).toBeInTheDocument();
      expect(screen.getByText('💨 Wind Speed:')).toBeInTheDocument();
    });

    it('should call getWeather API with correct city', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockResolvedValue(mockWeatherData);

      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      const submitButton = screen.getByText('🔍 Get Weather');

      await user.clear(input);
      await user.type(input, 'Paris');
      await user.click(submitButton);

      await waitFor(() => {
        expect(weatherApi.getWeather).toHaveBeenCalledWith('Paris');
      });
    });

    it('should fetch weather for different cities', async () => {
      const user = userEvent.setup();
      
      const londonData = { ...mockWeatherData, city: 'London', temperature: 15 };
      const parisData = { ...mockWeatherData, city: 'Paris', temperature: 18 };

      weatherApi.getWeather
        .mockResolvedValueOnce(londonData)
        .mockResolvedValueOnce(parisData);

      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      const submitButton = screen.getByText('🔍 Get Weather');

      // First fetch - London
      await user.click(submitButton);
      await waitFor(() => {
        expect(screen.getByText('🌤️ London')).toBeInTheDocument();
      });
      expect(screen.getByText('15°C')).toBeInTheDocument();

      // Second fetch - Paris
      await user.clear(input);
      await user.type(input, 'Paris');
      await user.click(submitButton);

      await waitFor(() => {
        expect(screen.getByText('🌤️ Paris')).toBeInTheDocument();
      });
      expect(screen.getByText('18°C')).toBeInTheDocument();
    });
  });

  describe('Error State', () => {
    it('should display error message when fetch fails', async () => {
      const user = userEvent.setup();
      const errorMessage = 'Weather API error: City not found';
      weatherApi.getWeather.mockRejectedValue(new Error(errorMessage));

      render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      await waitFor(() => {
        expect(screen.getByText('❌ Error')).toBeInTheDocument();
      });

      expect(screen.getByText(errorMessage)).toBeInTheDocument();
    });

    it('should have correct error state structure', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockRejectedValue(new Error('Test error'));

      const { container } = render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      await waitFor(() => {
        expect(container.querySelector('.weather-error')).toBeInTheDocument();
      });

      const errorDiv = container.querySelector('.weather-error');
      expect(errorDiv.querySelector('h4')).toHaveTextContent('❌ Error');
    });

    it('should clear previous weather data when new fetch fails', async () => {
      const user = userEvent.setup();
      
      weatherApi.getWeather
        .mockResolvedValueOnce(mockWeatherData)
        .mockRejectedValueOnce(new Error('Network error'));

      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      const submitButton = screen.getByText('🔍 Get Weather');

      // First successful fetch
      await user.click(submitButton);
      await waitFor(() => {
        expect(screen.getByText('🌤️ London')).toBeInTheDocument();
      });

      // Second failed fetch
      await user.clear(input);
      await user.type(input, 'InvalidCity');
      await user.click(submitButton);

      await waitFor(() => {
        expect(screen.getByText('❌ Error')).toBeInTheDocument();
      });

      // Previous weather data should be cleared
      expect(screen.queryByText('🌤️ London')).not.toBeInTheDocument();
    });

    it('should clear error when new successful fetch occurs', async () => {
      const user = userEvent.setup();
      
      weatherApi.getWeather
        .mockRejectedValueOnce(new Error('Network error'))
        .mockResolvedValueOnce(mockWeatherData);

      render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');

      // First failed fetch
      await user.click(submitButton);
      await waitFor(() => {
        expect(screen.getByText('❌ Error')).toBeInTheDocument();
      });

      // Second successful fetch
      await user.click(submitButton);
      await waitFor(() => {
        expect(screen.getByText('🌤️ London')).toBeInTheDocument();
      });

      // Error should be cleared
      expect(screen.queryByText('❌ Error')).not.toBeInTheDocument();
    });
  });

  describe('API Integration', () => {
    it('should call weather API with user-provided city name', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockResolvedValue(mockWeatherData);

      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      const submitButton = screen.getByText('🔍 Get Weather');

      await user.clear(input);
      await user.type(input, 'Tokyo');
      await user.click(submitButton);

      await waitFor(() => {
        expect(weatherApi.getWeather).toHaveBeenCalledWith('Tokyo');
      });

      expect(weatherApi.getWeather).toHaveBeenCalledTimes(1);
    });

    it('should display CVE information in footer', () => {
      render(<Weather />);

      expect(screen.getByText(/axios@1.5.1 which has CVE-2023-45857/)).toBeInTheDocument();
      expect(screen.getByText(/FALSE POSITIVE/)).toBeInTheDocument();
    });

    it('should handle special characters in city names', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockResolvedValue(mockWeatherData);

      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      const submitButton = screen.getByText('🔍 Get Weather');

      const cityWithSpecialChars = "Saint-Étienne";
      await user.clear(input);
      await user.type(input, cityWithSpecialChars);
      await user.click(submitButton);

      await waitFor(() => {
        expect(weatherApi.getWeather).toHaveBeenCalledWith(cityWithSpecialChars);
      });
    });
  });

  describe('Component Structure', () => {
    it('should have correct CSS classes', () => {
      const { container } = render(<Weather />);

      expect(container.querySelector('.weather')).toBeInTheDocument();
      expect(container.querySelector('.weather-form')).toBeInTheDocument();
      expect(container.querySelector('.form-group')).toBeInTheDocument();
      expect(container.querySelector('.popular-cities')).toBeInTheDocument();
      expect(container.querySelector('.weather-footer')).toBeInTheDocument();
    });

    it('should have correct form structure', () => {
      const { container } = render(<Weather />);

      const form = container.querySelector('form');
      expect(form).toBeInTheDocument();

      const input = form.querySelector('input[type="text"]');
      expect(input).toBeInTheDocument();
      expect(input).toHaveAttribute('id', 'city');

      const submitButton = form.querySelector('button[type="submit"]');
      expect(submitButton).toBeInTheDocument();
    });

    it('should render weather result with correct structure', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockResolvedValue(mockWeatherData);

      const { container } = render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      await waitFor(() => {
        expect(container.querySelector('.weather-result')).toBeInTheDocument();
      });

      const result = container.querySelector('.weather-result');
      expect(result.querySelector('.weather-header')).toBeInTheDocument();
      expect(result.querySelector('.weather-details')).toBeInTheDocument();
      expect(result.querySelectorAll('.weather-item').length).toBe(4);
    });
  });

  describe('Accessibility', () => {
    it('should have accessible form labels', () => {
      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      expect(input).toHaveAttribute('id', 'city');
    });

    it('should have accessible buttons', () => {
      render(<Weather />);

      const submitButton = screen.getByRole('button', { name: /Get Weather/i });
      expect(submitButton).toBeInTheDocument();

      const cityButtons = screen.getAllByRole('button', { name: /London|New York|Tokyo|Paris|Sydney/ });
      expect(cityButtons.length).toBe(5);
    });

    it('should have semantic HTML structure', () => {
      const { container } = render(<Weather />);

      expect(container.querySelector('form')).toBeInTheDocument();
      expect(container.querySelector('label')).toBeInTheDocument();
      expect(container.querySelector('input')).toBeInTheDocument();
      expect(container.querySelectorAll('button').length).toBeGreaterThan(0);
    });

    it('should disable submit button during loading', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockImplementation(() => new Promise(() => {}));

      render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      await waitFor(() => {
        expect(submitButton).toBeDisabled();
      });
    });
  });

  describe('Form Submission', () => {
    it('should submit form on Enter key press', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockResolvedValue(mockWeatherData);

      render(<Weather />);

      const input = screen.getByLabelText('🌍 Enter City Name:');
      
      await user.clear(input);
      await user.type(input, 'Paris{Enter}');

      await waitFor(() => {
        expect(weatherApi.getWeather).toHaveBeenCalledWith('Paris');
      });
    });

    it('should prevent default form submission', async () => {
      const user = userEvent.setup();
      weatherApi.getWeather.mockResolvedValue(mockWeatherData);

      render(<Weather />);

      const submitButton = screen.getByText('🔍 Get Weather');
      await user.click(submitButton);

      // If default wasn't prevented, page would reload
      // The fact that we can check for weather data means it worked
      await waitFor(() => {
        expect(screen.getByText('🌤️ London')).toBeInTheDocument();
      });
    });
  });
});

// Made with Bob