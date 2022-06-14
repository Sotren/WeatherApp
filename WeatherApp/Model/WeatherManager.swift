//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Станислав Москальцов  on 14.06.2022.
//

import Foundation
import Alamofire

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=13f26fc1012df059f2780615158329a4&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString:String) {
        if let url = URL(string: urlString) {
            let session =  URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            let id = (decodedData.weather[0].id)
            let temp = decodedData.main.temp
            let name = decodedData.name
            let pressure = decodedData.main.pressure
            let dt = decodedData.dt
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp,dataTime: dt, pressure: pressure)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
