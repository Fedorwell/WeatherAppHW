//
//  Weather.swift
//  WeatherAppHW
//
//  Created by mac on 19.06.2023.
//


struct Weather: Decodable {
    
    // MARK: - Weather
    struct Weather: Codable {
        let latitude, longitude, generationtimeMS: Double
        let utcOffsetSeconds: Int
        let timezone, timezoneAbbreviation: String
        let elevation: Int
        let currentWeather: CurrentWeather
        let hourlyUnits: HourlyUnits
        let hourly: Hourly
        
        enum CodingKeys: String, CodingKey {
            case latitude, longitude
            case generationtimeMS = "generationtime_ms"
            case utcOffsetSeconds = "utc_offset_seconds"
            case timezone
            case timezoneAbbreviation = "timezone_abbreviation"
            case elevation
            case currentWeather = "current_weather"
            case hourlyUnits = "hourly_units"
            case hourly
        }
    }
    
    // MARK: - CurrentWeather
    struct CurrentWeather: Codable {
        let temperature, windspeed: Double
        let winddirection, weathercode, isDay: Int
        let time: String
        
        enum CodingKeys: String, CodingKey {
            case temperature, windspeed, winddirection, weathercode
            case isDay = "is_day"
            case time
        }
    }
    
    // MARK: - Hourly
    struct Hourly: Codable {
        let time: [String]
        let temperature2M: [Double]
        let relativehumidity2M: [Int]
        let windspeed10M: [Double]
        
        enum CodingKeys: String, CodingKey {
            case time
            case temperature2M = "temperature_2m"
            case relativehumidity2M = "relativehumidity_2m"
            case windspeed10M = "windspeed_10m"
        }
    }
    
    // MARK: - HourlyUnits
    struct HourlyUnits: Codable {
        let time, temperature2M, relativehumidity2M, windspeed10M: String
        
        enum CodingKeys: String, CodingKey {
            case time
            case temperature2M = "temperature_2m"
            case relativehumidity2M = "relativehumidity_2m"
            case windspeed10M = "windspeed_10m"
        }
    }
    
}
