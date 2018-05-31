//
//  MealDetailView.swift
//  food-tracker
//
//  Created by Nazmul Islam on 23/4/18.
//  Copyright © 2018 Nazmul Islam. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class MealDetailView: UIView {
    //MARK: Properties
    let mealNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter meal name"
        return textField
    }()
    
    let mealImageView: UIImageView = {
        let defaultPhoto = UIImage(named: "defaultPhoto")
        let imageView = UIImageView(image: defaultPhoto)
        imageView.widthAnchor.constraint(equalToConstant: 320.0).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0/1.0).isActive = true
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let mealRatingControl: RatingControl = {
        let ratingControl = RatingControl()
        return ratingControl
    }()
    
    lazy var verticalStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.mealNameTextField, self.mealImageView, self.mealRatingControl])
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = CGFloat(8.0)
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = UIStackViewDistribution.fill
        return stackView
    }()
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Methods
    private func setupViews() {
        self.setSubviewForAutoLayout(self.verticalStackView)
        self.backgroundColor = UIColor.white
        
        self.mealNameTextField.snp.makeConstraints {(make: ConstraintMaker) -> Void in
            make.width.equalToSuperview()
        }
        
        self.verticalStackView.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(8.0)
            make.centerX.equalToSuperview()
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(8.0)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(8.0)
        }
    }
}
