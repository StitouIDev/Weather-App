//
//  WeatherManager.swift
//  Weather
//
//  Created by HAMZA on 28/5/2022.
//

import Foundation
import CoreLocation

protocol WeatherApiDelegate {
    func updateWeather(_ weatherApi: WeatherApi,_ weather: WeatherModel)
    func errorFail(error: Error)
}

struct WeatherApi {
    let WeatherUrl = "https://api.openweathermap.org/data/2.5/weather?APPID=9653d87619a8ffed2065d694cadba934&units=metric"
    
    var delegate: WeatherApiDelegate?
    
    func getWeather(city: String){
        let urlString = "\(WeatherUrl)&q=\(city)"
        getRequest(with: urlString)
    }
    
    func getWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees){
        let urlString = "\(WeatherUrl)&lat=\(latitude)&lon=\(longitute)"
        getRequest(with: urlString)
    }
    
    
    
    func getRequest(with urlString: String){
        guard let url = URL(string: urlString) else  { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else  {
                delegate?.errorFail(error: error!)
                return
            }
            guard let data = data else  { return }
            guard let weather = self.parseJson(data) else { return }
            self.delegate?.updateWeather(self, weather)
            
            
        }
        
        task.resume()
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let jsonDecoder = JSONDecoder()
        do {
            let weather = try jsonDecoder.decode(WeatherData.self, from: weatherData)
            let id = weather.weather[0].id
            let temp = weather.main.temp
            let name = weather.name
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weatherModel
        } catch {
            delegate?.errorFail(error: error)
            return nil
        }
    }
}

