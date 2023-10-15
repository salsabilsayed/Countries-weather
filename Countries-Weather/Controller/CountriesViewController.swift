//
//  CountriesViewController.swift
//  Countries-Weather
//
//  Created by ifts 25 on 08/04/23.
//

import UIKit
import Kingfisher

class CountriesViewController: UIViewController {
    
    @IBOutlet weak var searchTF: UISearchBar!
    @IBOutlet weak var countriesCollection: UICollectionView!
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    var countriesArray: [CountryModel] = []
    var isSearching: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesCollection.dataSource = self
        countriesCollection.delegate = self
        
        activityLoader.startAnimating()
        fetchAllCountries()
    
    }
    
    
    @IBAction func favouriteBtnPressed(_ sender: UIButton) {
        var superview = sender.superview
            while let view = superview, !(view is UICollectionViewCell) {
                superview = view.superview
            }
            guard let cell = superview as? UICollectionViewCell else {
                print("button is not contained in a table view cell")
                return
            }
            guard let indexPath = countriesCollection.indexPath(for: cell) else {
                print("failed to get index path for cell containing button")
                return
            }
            
            print("button is in row \(indexPath.row)")

        if let savedCountries = Country.loadFromDevice() {
            Country.fovouriteCountries = savedCountries
            Country.fovouriteCountries.append(countriesArray[indexPath.row])
            Country.saveToDevice(countries: Country.fovouriteCountries)
        }
            
    }
    
    func fetchAllCountries(){
        NetworkingService.shared.fetchRequest(name: "all") { result in
            self.countriesArray = result
            DispatchQueue.main.async {
                self.countriesCollection.reloadData()
                self.activityView.isHidden = true
                self.activityLoader.stopAnimating()
                self.activityLoader.isHidden = true
            }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = countriesCollection.indexPathsForSelectedItems {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.recievedCountry = countriesArray[indexPath.first!.row]
        }
    }
    
}


//MARK: - Collectionview delegate and data source

extension CountriesViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countriesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = countriesCollection.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        let country = countriesArray[indexPath.row]
        cell.nameLabel.text = country.name.common
        cell.regionLabel.text = "Region: \(country.region)"
        if let capital = country.capital {
            cell.capitalLabel.text = "Capital: \(capital[0])"
        }
        
        cell.countryImage.kf.setImage(with: URL(string: country.flags.png))
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        collectionView.contentInset = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
        let cellWidth = (collectionView.frame.width / 2) - 10
        
        return CGSize(width: cellWidth, height: 250)
             
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
    
}


//MARK: - Searchbar delegate

extension CountriesViewController: UISearchBarDelegate {
 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     if(self.searchTF.text == ""){
         self.searchTF.endEditing(true)
         self.searchTF.setShowsCancelButton(false,animated: true)
         fetchAllCountries()
         
     }

   }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTF.endEditing(true)
        isSearching = true
        NetworkingService.shared.fetchRequest(name: "name/\(searchTF.text!)") { result in
            self.countriesArray = result
            DispatchQueue.main.async {
                self.countriesCollection.reloadData()
            }
        }
    }
}
