//
//  RestaurantTableViewCell.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 20.03.23.
//

import UIKit
import Kingfisher

protocol RestaurantTableViewCellDelegate: AnyObject {
    func didTapFavorite(_ sender: UIButton)
}

final class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!
    @IBOutlet private weak var restaurantImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    weak var delegate: RestaurantTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantImageView.layer.cornerRadius = 10
        restaurantImageView.clipsToBounds = true
    }
    
    func configure(model: RestaurantViewData) {
        nameLabel.text = model.name
        shortDescriptionLabel.text = model.shortDescription
        setRestaurantImageView(with: model.imageURL)
        favoriteButton.isSelected = model.isFavorite
        favoriteButton.addTarget(
            self,
            action: #selector(favoriteButtonTapped),
            for: .touchUpInside
        )
    }
}

private extension RestaurantTableViewCell {
    func setRestaurantImageView(with imageURL: URL) {
        let processor = DownsamplingImageProcessor(size: restaurantImageView.bounds.size)
        restaurantImageView.kf.indicatorType = .activity
        restaurantImageView.kf.setImage(
            with: imageURL,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.didTapFavorite(sender)
    }
}
