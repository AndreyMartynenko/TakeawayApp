//
//  RestaurantsViewController.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation
import UIKit

class RestaurantsViewController: UITableViewController {
    
    // MARK: - Properties
    
    fileprivate var viewModel: RestaurantViewModel!
    fileprivate var favouriteAction: CellIndexPathAction!
    
    fileprivate lazy var sortingValuesView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var sortingValuesViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view = sortingValuesView
        return viewController
    }()
    
    fileprivate lazy var sortingValuesAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "Sorting values", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
            self?.viewModel.sort()
        }))
        alertController.setValue(sortingValuesViewController, forKey: "contentViewController")
        return alertController
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RestaurantViewModel(delegate: self)
        viewModel.start()
        
        title = "Restaurants"
        tableView.tableFooterView = UIView()
        
        configureActions()
    }
    
    deinit {
        viewModel.stop()
        viewModel = nil
    }
    
    // MARK: - Actions
    
    fileprivate func configureActions() {
        favouriteAction = { [weak self] (indexPath) in
            self?.viewModel.toggleFavourite(at: indexPath.row)
        }
    }
    
    @IBAction func sortingButtonPressed(_ sender: UIBarButtonItem) {
        sortingValuesView.selectRow(viewModel.selectedSortingValueIndex, inComponent: 0, animated: true)
        present(sortingValuesAlertController, animated: true, completion: nil)
    }
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        if let text = sender.text {
            viewModel.filter(by: text)
        }
    }
}

// MARK: - UITableView delegate methods

extension RestaurantsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        
        cell.configure(name: viewModel.cellName(at: indexPath.row),
                       status: viewModel.cellStatus(at: indexPath.row),
                       sortingValue: viewModel.cellSortingValue(at: indexPath.row),
                       isFavourite: viewModel.cellIsFavourite(at: indexPath.row),
                       indexPath: indexPath,
                       action: favouriteAction)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.itemPressed(at: indexPath.row)
    }
    
}

// MARK: - RestaurantViewModel delegate methods

extension RestaurantsViewController: RestaurantViewModelDelegate {
    
    func onRestaurantsUpdated() {
        tableView.reloadData()
    }
    
    func onError(error: ClientError) {
        print(error.localizedDescription)
    }
    
}

// MARK: - UIPickerView delegate and data source methods

extension RestaurantsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.sortingValuesCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.sortingValue(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.sortingValueSelected(at: row)
    }
    
}

// MARK: - UITextField delegate methods

extension RestaurantsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        viewModel.sort()
        
        return true
    }
    
}
