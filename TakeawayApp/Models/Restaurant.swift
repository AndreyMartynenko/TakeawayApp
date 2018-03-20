//
//  Restaurant.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation

struct Restaurant: Decodable {
    
    let name: String?
    let status: String?
    let sortingValues: SortingValue?
    
    var statusOrder: Int {
        if status?.lowercased() == "open" {
            return 0
        } else if status?.lowercased() == "order ahead" {
            return 1
        } else if status?.lowercased() == "closed" {
            return 2
        }
        
        return 3
    }
    
    var isFavourite: Bool {
        return DataObject.isFavourite(restaurant: name)
    }
    
    func setFavourite() {
        DataObject.setFavourite(restaurant: name)
    }
    
    func removeFavourite() {
        DataObject.removeFavourite(restaurant: name)
    }
    
    var favouriteOrder: Int {
        return isFavourite ? 0 : 1
    }

}

// MARK: - Sorting

extension Restaurant {
    
    fileprivate static func sorted(lhsObject: Restaurant, rhsObject: Restaurant, lhsValue: Float = 0, rhsValue: Float = 0) -> Bool {
        return (lhsObject.favouriteOrder, lhsObject.statusOrder, lhsValue) < (rhsObject.favouriteOrder, rhsObject.statusOrder, rhsValue)
    }
    
    static let openingState: (Restaurant, Restaurant) -> Bool = {
        return sorted(lhsObject: $0, rhsObject: $1)
    }
    
    static let bestMatch: (Restaurant, Restaurant) -> Bool = {
        guard let lhs = $0.sortingValues?.bestMatch, let rhs = $1.sortingValues?.bestMatch else { return false }
        
        return sorted(lhsObject: $0, rhsObject: $1, lhsValue: rhs, rhsValue: lhs) // Z->A
    }
    
    static let newest: (Restaurant, Restaurant) -> Bool = {
        guard let lhs = $0.sortingValues?.newest, let rhs = $1.sortingValues?.newest else { return false }
        
        return sorted(lhsObject: $0, rhsObject: $1, lhsValue: rhs, rhsValue: lhs) // Z->A
    }
    
    static let ratingAverage: (Restaurant, Restaurant) -> Bool = {
        guard let lhs = $0.sortingValues?.ratingAverage, let rhs = $1.sortingValues?.ratingAverage else { return false }
        
        return sorted(lhsObject: $0, rhsObject: $1, lhsValue: rhs, rhsValue: lhs) // Z->A
    }
    
    static let distance: (Restaurant, Restaurant) -> Bool = {
        guard let lhs = $0.sortingValues?.distance, let rhs = $1.sortingValues?.distance else { return false }
        
        return sorted(lhsObject: $0, rhsObject: $1, lhsValue: lhs, rhsValue: rhs)
    }
    
    static let popularity: (Restaurant, Restaurant) -> Bool = {
        guard let lhs = $0.sortingValues?.popularity, let rhs = $1.sortingValues?.popularity else { return false }
        
        return sorted(lhsObject: $0, rhsObject: $1, lhsValue: rhs, rhsValue: lhs) // Z->A
    }
    
    static let averageProductPrice: (Restaurant, Restaurant) -> Bool = {
        guard let lhs = $0.sortingValues?.averageProductPrice, let rhs = $1.sortingValues?.averageProductPrice else { return false }
        
        return sorted(lhsObject: $0, rhsObject: $1, lhsValue: lhs, rhsValue: rhs)
    }
    
    static let deliveryCosts: (Restaurant, Restaurant) -> Bool = {
        guard let lhs = $0.sortingValues?.deliveryCosts, let rhs = $1.sortingValues?.deliveryCosts else { return false }
        
        return sorted(lhsObject: $0, rhsObject: $1, lhsValue: lhs, rhsValue: rhs)
    }
    
    static let minCost: (Restaurant, Restaurant) -> Bool = {
        guard let lhs = $0.sortingValues?.minCost, let rhs = $1.sortingValues?.minCost else { return false }
        
        return sorted(lhsObject: $0, rhsObject: $1, lhsValue: lhs, rhsValue: rhs)
    }
    
}
