//
//  FavouritesViewController.swift
//  Countries-Weather
//
//  Created by ifts 25 on 20/04/23.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favouritesTable: UITableView!
    @IBOutlet weak var noItemsView: UIView!
    
    var favCountries: [CountryModel] = [] {
        didSet {
            Country.saveToDevice(countries: favCountries)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesTable.dataSource = self
        favouritesTable.delegate = self
        noItemsView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let savedCountries = Country.loadFromDevice() {
            if savedCountries.isEmpty {
                noItemsView.isHidden = false
            }else{
                noItemsView.isHidden = true
            }
            favCountries = savedCountries
            self.favouritesTable.reloadData()
        }else {
            favCountries = Country.fovouriteCountries
            noItemsView.isHidden = false
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favToDetails" {
            if let indexPath = favouritesTable.indexPathForSelectedRow {
                let detailsVc = segue.destination as? DetailsViewController
                detailsVc?.recievedCountry = favCountries[indexPath.row]
            }
        }
    }
    
}

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favouritesTable.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as? FavouriteTableViewCell else { return UITableViewCell() }
        
        cell.favCellView.layer.cornerRadius = 15
        cell.favCellView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        cell.countryImage.layer.cornerRadius = 15
        
        let country = favCountries[indexPath.row]
        
        cell.nameLbl.text = country.name.common
        
        cell.countryImage.kf.setImage(with: URL(string: country.flags.png))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "favToDetails", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favCountries.remove(at: indexPath.row)
            if !favCountries.isEmpty{
                Country.saveToDevice(countries: favCountries)
            }
            
            favouritesTable.reloadData()
            if favCountries.isEmpty {
                noItemsView.isHidden = false
            }
        }
    }
    
}
