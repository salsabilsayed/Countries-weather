//
//  DetailsViewController.swift
//  Countries-Weather
//
//  Created by ifts 25 on 09/04/23.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {
    
    var recievedCountry: CountryModel? = nil
    
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var populationLbl: UILabel!
    @IBOutlet weak var regionLbl: UILabel!
    @IBOutlet weak var subregionLbl: UILabel!
    @IBOutlet weak var capitalLbl: UILabel!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var weatherBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        mapBtn.layer.cornerRadius = 10
        weatherBtn.layer.cornerRadius = 10
        if let country = recievedCountry {
            nameLbl.text = country.name.common
            populationLbl.text = "\(country.population)"
            regionLbl.text = country.region
            subregionLbl.text = country.subregion
            if let capital = country.capital {
                capitalLbl.text = capital[0]
            }
            countryImageView.kf.setImage(with: URL(string: country.flags.png))
        }
        
    }
    
    
    @IBAction func showMapPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    
    @IBAction func showWeatherPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "toWeather", sender: nil)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap"{
            let mapVC = segue.destination as! MapViewController
            if let country = recievedCountry {
                mapVC.recievedCoordinates = country.latlng
            }
        }else if segue.identifier == "toWeather" {
            let weatherVC = segue.destination as! WeatherViewController
            if let country = recievedCountry {
                if let capital = country.capital{
                    weatherVC.city = capital[0]
                }
            }
        }
    }
    
}
