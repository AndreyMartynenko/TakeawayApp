//
//  RestaurantViewModelTests.swift
//  TakeawayAppTests
//
//  Created by Andrey on 3/19/18.
//

import XCTest
@testable import TakeawayApp

class RestaurantViewModelTests: XCTestCase {
    
    var sut: RestaurantViewModel!
    
    override func setUp() {
        super.setUp()
        
        UserDefaults.standard.addSuite(named: "Testing")
        sut = RestaurantViewModel(delegate: nil)
        sut.fetch(fromClient: MockRestaurantClient())
    }
    
    override func tearDown() {
        sut = nil
        UserDefaults.standard.removeSuite(named: "Testing")
        
        super.tearDown()
    }
    
    func testItemsCount() {
        XCTAssertEqual(sut.itemsCount, 4)
    }
    
    func testItemAtIndex() {
        let expectedValue = Restaurant(name: "TestNameAA", status: "open", sortingValues: SortingValue(bestMatch: 4.0, newest: 100.0, ratingAverage: 4.5, distance: 1190, popularity: 17.0, averageProductPrice: 1500, deliveryCosts: 200, minCost: 1000))
        
        XCTAssertEqual(sut.item(at: 0).name, expectedValue.name)
        XCTAssertEqual(sut.item(at: 0).status, expectedValue.status)
        
        XCTAssertEqual(sut.item(at: 0).sortingValues?.bestMatch, expectedValue.sortingValues?.bestMatch)
        XCTAssertEqual(sut.item(at: 0).sortingValues?.newest, expectedValue.sortingValues?.newest)
        XCTAssertEqual(sut.item(at: 0).sortingValues?.ratingAverage, expectedValue.sortingValues?.ratingAverage)
        XCTAssertEqual(sut.item(at: 0).sortingValues?.distance, expectedValue.sortingValues?.distance)
        XCTAssertEqual(sut.item(at: 0).sortingValues?.popularity, expectedValue.sortingValues?.popularity)
        XCTAssertEqual(sut.item(at: 0).sortingValues?.averageProductPrice, expectedValue.sortingValues?.averageProductPrice)
        XCTAssertEqual(sut.item(at: 0).sortingValues?.deliveryCosts, expectedValue.sortingValues?.deliveryCosts)
        XCTAssertEqual(sut.item(at: 0).sortingValues?.minCost, expectedValue.sortingValues?.minCost)
    }
    
    func testSorting() {
        sut.sortingValueSelected(at: 0) // bestMatch
        sut.sort()

        XCTAssertEqual(sut.item(at: 0).name, "TestNameAA")
        XCTAssertEqual(sut.item(at: 1).name, "TestNameDD")
        XCTAssertEqual(sut.item(at: 2).name, "TestNameCC")
        XCTAssertEqual(sut.item(at: 3).name, "TestNameBB")
        
        sut.sortingValueSelected(at: 5) // averageProductPrice
        sut.sort()
        
        XCTAssertEqual(sut.item(at: 0).name, "TestNameDD")
        XCTAssertEqual(sut.item(at: 1).name, "TestNameAA")
        XCTAssertEqual(sut.item(at: 2).name, "TestNameCC")
        XCTAssertEqual(sut.item(at: 3).name, "TestNameBB")
    }
    
    func testFiltering() {
        XCTAssertEqual(sut.itemsCount, 4)
        XCTAssertEqual(sut.item(at: 0).name, "TestNameAA")
        
        sut.filter(by: "BB")
        
        XCTAssertEqual(sut.itemsCount, 1)
        XCTAssertEqual(sut.item(at: 0).name, "TestNameBB")
    }
    
    func testFavourite() {
        XCTAssertFalse(sut.item(at: 2).isFavourite)
        
        sut.toggleFavourite(at: 2)
        
        XCTAssertTrue(sut.item(at: 2).isFavourite)
        
        sut.toggleFavourite(at: 2)
        
        XCTAssertFalse(sut.item(at: 2).isFavourite)
    }
    
}
