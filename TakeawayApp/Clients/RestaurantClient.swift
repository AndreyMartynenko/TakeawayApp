//
//  RestaurantClient.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation

class RestaurantClient: GenericClient, Gettable {
    
    func retrieve(completion: @escaping (Result<RestaurantsResponse?, ClientError>) -> Void) {
        fetch(fileName: "data", decode: { (json) -> RestaurantsResponse? in
            guard let restaurants = json as? RestaurantsResponse else { return nil }
            return restaurants
        }, completion: completion)
    }
    
}
