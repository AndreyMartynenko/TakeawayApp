//
//  ViewController.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var viewModel: RestaurantViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RestaurantViewModel(delegate: self)
        viewModel.start()
    }

}

extension ViewController: RestaurantViewModelDelegate {
    
    func onRestaurantsUpdated() {
        print("__blah")
    }
    
    func onError(error: ClientError) {
        print("__bleh")
    }
    
}
