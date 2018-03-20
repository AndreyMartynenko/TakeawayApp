//
//  DataObject.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation

class DataObject: NSObject {
    
    fileprivate static let favouriteRestaurantsKey = "FavouriteRestaurants"
    
    static func isFavourite(restaurant name: String?) -> Bool {
        guard
            let name = name,
            let favourites = UserDefaults.standard.object(forKey: DataObject.favouriteRestaurantsKey) as? [String] else {
                return false
        }
        
        return favourites.filter( { $0.lowercased().contains(name.lowercased()) } ).count == 1
    }
    
    static func setFavourite(restaurant name: String?) {
        guard let name = name else { return }
        
        var favourites: [String] = []
        if let storedSavourites = UserDefaults.standard.array(forKey: DataObject.favouriteRestaurantsKey) as? [String] {
            favourites = storedSavourites
        }
        if let index = favourites.index(of: name) {
            favourites[index] = name
        } else {
            favourites.append(name)
        }
        UserDefaults.standard.set(favourites, forKey: DataObject.favouriteRestaurantsKey)
        UserDefaults.standard.synchronize()
    }
    
    static func removeFavourite(restaurant name: String?) {
        guard
            let name = name,
            var favourites = UserDefaults.standard.array(forKey: DataObject.favouriteRestaurantsKey) as? [String],
            let index = favourites.index(of: name) else {
                return
        }
        
        favourites.remove(at: index)
        UserDefaults.standard.set(favourites, forKey: DataObject.favouriteRestaurantsKey)
        UserDefaults.standard.synchronize()
    }
    
}
