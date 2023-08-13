//
//  FavouriteTableViewCell.swift
//  Countries-Weather
//
//  Created by ifts 25 on 20/04/23.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var favCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
