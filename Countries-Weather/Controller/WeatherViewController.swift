//
//  WeatherViewController.swift
//  Countries-Weather
//
//  Created by ifts 25 on 11/04/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sunriseView: UIView!
    @IBOutlet weak var sunsetView: UIView!
    
    var weather : Weather?
    var city: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        guard let receviedCity = city else { return }
        fetchWeather(city: receviedCity)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
    }
    
    func updateUI(){
        weatherImage.tintColor = .white
        tempLabel.textColor = .white
        sunriseView.backgroundColor = UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        sunsetView.backgroundColor = UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        sunsetView.layer.cornerRadius = 10
        sunriseView.layer.cornerRadius = 10
        tempLabel.isHidden = true
        nameLabel.isHidden = true
        sunsetLbl.isHidden = true
        sunriseLbl.isHidden = true
    }
    
    func fetchWeather(city:String){
        NetworkingService.shared.fetchWeather(city: city) { result in
            DispatchQueue.main.async {
                self.tempLabel.isHidden = false
                self.nameLabel.isHidden = false
                self.sunsetLbl.isHidden = false
                self.sunriseLbl.isHidden = false
                self.weatherImage.image = UIImage(systemName: result.weather[0].conditionName)
                self.tempLabel.text = result.main.tempratureString
                self.nameLabel.text = result.name
                self.sunriseLbl.text = self.dateFormat(dateResult: result.sys.sunrise)
                self.sunsetLbl.text = self.dateFormat(dateResult: result.sys.sunset)
            }

        }
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func dateFormat(dateResult: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(dateResult))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let stringDate: String = formatter.string(from: date as Date)
        print(stringDate)

        return stringDate
    }
    
}


extension WeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchWeather(city: searchBar.text!)
    }
}





