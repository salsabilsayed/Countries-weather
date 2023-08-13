//
//  NetworkingService.swift
//  Countries-Weather
//
//  Created by ifts 25 on 08/04/23.
//

import Foundation

struct NetworkingService {
    static var shared = NetworkingService()
    
    let baseURL = "https://restcountries.com/v3.1/"
    
    func fetchRequest(name: String, completion: @escaping ([CountryModel]) -> Void) {
        let url = baseURL + name
        guard let url = URL(string: url) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _ ,  error in
            if error != nil {
                print(error!)
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData =  try decoder.decode([CountryModel].self, from: data)
                    completion(decodedData)
                }catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func fetchWeather(city: String, completion: @escaping (WeatherResponse) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=13fe7fd36847d860cbdc93b0b1b6ac12&units=metric"
        
        guard let url = URL(string: url) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _ ,  error in
            if error != nil {
                print(error!)
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData =  try decoder.decode(WeatherResponse.self, from: data)
                    completion(decodedData)
                }catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
