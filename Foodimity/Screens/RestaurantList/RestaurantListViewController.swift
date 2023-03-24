//
//  RestaurantListViewController.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 19.03.23.
//

import UIKit

final class RestaurantListViewController: UIViewController {
    private var viewModel = RestaurantListViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        viewModel.onViewDidLoad()
    }
}

extension RestaurantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.className, for: indexPath) as! RestaurantTableViewCell
        let model = viewModel.getItemAt(index: indexPath.row)
        cell.configure(model: model)
        cell.delegate = self
        return cell
    }
}

extension RestaurantListViewController: RestaurantTableViewCellDelegate {
    func didTapFavorite(_ sender: UIButton) {
        guard
            let cell = sender.superview?.superview as? RestaurantTableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        viewModel.restaurantMarked(
            with: sender.isSelected,
            at: indexPath.row
        )
    }
}

private extension RestaurantListViewController {
    func setupViewModel() {
        viewModel.onStateChange = { state in
            DispatchQueue.main.async {
                self.update(state)
            }
        }
    }
    
    func update(_ state: RestaurantListState) {
        switch state {
        case .loading:
            view.displayAnimatedActivityIndicatorView()
        case let .error(message):
            showAlert(title: "Error", message: message)
        case .finished:
            view.hideAnimatedActivityIndicatorView()
        case .update:
            tableView.reloadData()
        }
    }
}
