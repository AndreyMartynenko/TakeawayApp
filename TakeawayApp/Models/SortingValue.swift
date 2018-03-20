//
//  SortingValue.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation

enum SortingValueType: String, EnumCollection {
    
    case bestMatch = "Best match"
    case newest = "Newest"
    case ratingAverage = "Rating"
    case distance = "Distance"
    case popularity = "Popularity"
    case averageProductPrice = "Product price"
    case deliveryCosts = "Delivery costs"
    case minCost = "Min. order cost"
    
}

struct SortingValue: Decodable {
    
    let bestMatch: Float?
    let newest: Float?
    let ratingAverage: Float?
    let distance: Float?
    let popularity: Float?
    let averageProductPrice: Float?
    let deliveryCosts: Float?
    let minCost: Float?
    
}
