//
//  RestaurantCell.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation
import UIKit

typealias CellIndexPathAction = (IndexPath) -> Void

class RestaurantCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet fileprivate weak var sortingValueLabel: UILabel!
    @IBOutlet fileprivate weak var favouriteButton: UIButton!
    
    fileprivate var indexPath: IndexPath!
    fileprivate var favouriteAction: CellIndexPathAction!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        favouriteButton.setImage(UIImage(named: "ic_unfavorite"), for: .normal)
    }
    
    func configure(name: String?, status: String?, sortingValue: String?, isFavourite: Bool, indexPath: IndexPath, action: @escaping CellIndexPathAction) {
        nameLabel.text = name
        statusLabel.text = status
        sortingValueLabel.text = sortingValue
        favouriteButton.setImage(UIImage(named: isFavourite ? "ic_favorite" : "ic_unfavorite"), for: .normal)
        self.indexPath = indexPath
        favouriteAction = action
    }
    
    // MARK: - Actions
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        favouriteAction?(indexPath)
    }
    
}
