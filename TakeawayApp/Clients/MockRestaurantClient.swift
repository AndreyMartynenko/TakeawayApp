//
//  MockRestaurantClient.swift
//  TakeawayApp
//
//  Created by Andrey on 3/20/18.
//

import Foundation

class MockRestaurantClient: GenericClient, Gettable {
    
    func retrieve(completion: @escaping (Result<RestaurantsResponse?, ClientError>) -> Void) {
        fetch(fileName: "data_testing", decode: { (json) -> RestaurantsResponse? in
            guard let restaurants = json as? RestaurantsResponse else { return nil }
            return restaurants
        }, completion: completion)
    }
    
}
