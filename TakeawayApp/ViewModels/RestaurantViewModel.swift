//
//  RestaurantViewModel.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation

protocol RestaurantViewModelDelegate: class {
    
    func onRestaurantsUpdated()
    func onError(error: ClientError)

}

class RestaurantViewModel: NSObject {
    
    fileprivate weak var delegate: RestaurantViewModelDelegate?
    fileprivate var items: [Restaurant]
    fileprivate var filteredItems: [Restaurant]
    fileprivate var sortingValues: [SortingValueType]
    fileprivate var sortingValue: SortingValueType
    fileprivate var isFilterApplied: Bool
    
    init(delegate: RestaurantViewModelDelegate?) {
        self.delegate = delegate
        items = []
        filteredItems = []
        sortingValues = SortingValueType.allValues
        sortingValue = SortingValueType.bestMatch
        isFilterApplied = false
        
        super.init()
    }
    
    func start() {
        fetch(fromClient: RestaurantClient())
    }
    
    func stop() {
        
    }
    
    func fetch<Client: Gettable>(fromClient client: Client) where Client.T == RestaurantsResponse {
        client.retrieve { [weak self] (result) in
            switch result {
            case .success(let restaurants):
                if let restaurants = restaurants?.restaurants {
                    self?.items = restaurants
                    self?.sort()
                    self?.delegate?.onRestaurantsUpdated()
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self?.delegate?.onError(error: error)
            }
        }
    }
    
    var itemsCount: Int {
        get {
            return isFilterApplied ? filteredItems.count : items.count
        }
    }
    
    func item(at index: Int) -> Restaurant {
        return isFilterApplied ? filteredItems[index] : items[index]
    }
    
    func itemPressed(at index: Int) {
        
    }
    
    func toggleFavourite(at index: Int) {
        var items = isFilterApplied ? filteredItems : self.items
        
        if items[index].isFavourite {
            items[index].removeFavourite()
        } else {
            items[index].setFavourite()
        }
        
        sort()
    }
    
}

// MARK: - Cell presentation items

extension RestaurantViewModel {
    
    func cellName(at index: Int) -> String? {
        return isFilterApplied ? filteredItems[index].name : items[index].name
    }
    
    func cellStatus(at index: Int) -> String? {
        return isFilterApplied ? filteredItems[index].status : items[index].status
    }
    
    func cellSortingValue(at index: Int) -> String? {
        guard let valueType = SortingValueType(rawValue: selectedSortingValue) else { return nil }
        
        var cellSortingValue: String? = nil
        var sortingValue: String? = nil
        let sortingValues = isFilterApplied ? filteredItems[index].sortingValues : items[index].sortingValues
        
        switch valueType {
        case .bestMatch:
            if let value = sortingValues?.bestMatch {
                sortingValue = String(format: "%.f", value)
            }
        case .newest:
            if let value = sortingValues?.newest {
                sortingValue = String(format: "%.f", value)
            }
        case .ratingAverage:
            if let value = sortingValues?.ratingAverage {
                sortingValue = String(format: "%.1f", value)
            }
        case .distance:
            if let value = sortingValues?.distance {
                sortingValue = "\(String(format: "%.f", value)) meters"
            }
        case .popularity:
            if let value = sortingValues?.popularity {
                sortingValue = String(format: "%.1f", value)
            }
        case .averageProductPrice:
            if let value = sortingValues?.averageProductPrice {
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "de_DE")
                formatter.numberStyle = .currency
                formatter.maximumFractionDigits = 2
                if let formattedValue = formatter.string(from: (value / 100) as NSNumber) {
                    sortingValue = "\(formattedValue)"
                }
            }
        case .deliveryCosts:
            if let value = sortingValues?.deliveryCosts {
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "de_DE")
                formatter.numberStyle = .currency
                formatter.maximumFractionDigits = 2
                if let formattedValue = formatter.string(from: (value / 100) as NSNumber) {
                    sortingValue = "\(formattedValue)"
                }
            }
        case .minCost:
            if let value = sortingValues?.minCost {
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "de_DE")
                formatter.numberStyle = .currency
                formatter.maximumFractionDigits = 2
                if let formattedValue = formatter.string(from: (value / 100) as NSNumber) {
                    sortingValue = "\(formattedValue)"
                }
            }
        }
        
        if let sortingValue = sortingValue {
            cellSortingValue = "\(selectedSortingValue): \(sortingValue)"
        }

        return cellSortingValue
    }
    
    func cellIsFavourite(at index: Int) -> Bool {
        return isFilterApplied ? filteredItems[index].isFavourite : items[index].isFavourite
    }
    
}

// MARK: - Sorting

extension RestaurantViewModel {
    
    var sortingValuesCount: Int {
        get {
            return sortingValues.count
        }
    }
    
    func sortingValue(at index: Int) -> String {
        return sortingValues[index].rawValue
    }
    
    var selectedSortingValue: String {
        get {
            return sortingValue.rawValue
        }
    }
    
    var selectedSortingValueIndex: Int {
        get {
            return sortingValues.index(of: sortingValue) ?? 0
        }
    }
    
    func sortingValueSelected(at index: Int) {
        sortingValue = sortingValues[index]
    }
    
    func sort() {
        guard let valueType = SortingValueType(rawValue: selectedSortingValue) else { return }
        
        var items = isFilterApplied ? filteredItems : self.items
        
        switch valueType {
        case .bestMatch:
            items = items.sorted(by: Restaurant.bestMatch)
        case .newest:
            items = items.sorted(by: Restaurant.newest)
        case .ratingAverage:
            items = items.sorted(by: Restaurant.ratingAverage)
        case .distance:
            items = items.sorted(by: Restaurant.distance)
        case .popularity:
            items = items.sorted(by: Restaurant.popularity)
        case .averageProductPrice:
            items = items.sorted(by: Restaurant.averageProductPrice)
        case .deliveryCosts:
            items = items.sorted(by: Restaurant.deliveryCosts)
        case .minCost:
            items = items.sorted(by: Restaurant.minCost)
        }
        
        if isFilterApplied {
            filteredItems = items
        } else {
            self.items = items
        }
        
        delegate?.onRestaurantsUpdated()
    }
    
}

// MARK: - Filtering

extension RestaurantViewModel {
    
    func filter(by name: String) {
        print("\(isFilterApplied), \(items.count), \(filteredItems.count)")
        if name.isEmpty {
            isFilterApplied = false
            delegate?.onRestaurantsUpdated()
            return
        }
        
        isFilterApplied = true
        filteredItems = items.filter( { $0.name != nil && $0.name!.lowercased().contains(name.lowercased()) } )
        delegate?.onRestaurantsUpdated()
    }
    
}
