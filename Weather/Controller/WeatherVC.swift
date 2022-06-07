//
//  ViewController.swift
//  Weather
//
//  Created by HAMZA on 27/5/2022.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    
    @IBOutlet weak var conditionImg: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    
    var weatherApi = WeatherApi()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        
        weatherApi.delegate = self
        searchTxtField.delegate = self
    }
    
    @IBAction func locationClicked(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}


extension WeatherVC: UITextFieldDelegate {
    
    @IBAction func searchClicked(_ sender: UIButton) {
        searchTxtField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTxtField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Add Location"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTxtField.text {
            weatherApi.getWeather(city: city)
        }
        
        searchTxtField.text = ""
    }
}



extension WeatherVC: WeatherApiDelegate {
    func updateWeather(_ weatherApi: WeatherApi,_ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLbl.text = weather.tempString
            self.conditionImg.image = UIImage(systemName: weather.conditonName)
            self.cityLbl.text = weather.cityName
        }
        
    }
    
    func errorFail(error: Error) {
        debugPrint(error.localizedDescription)
    }
    
}

extension WeatherVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherApi.getWeather(latitude: lat, longitute: lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
