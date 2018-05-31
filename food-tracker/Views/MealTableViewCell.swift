//
//  MealTableView.swift
//  food-tracker
//
//  Created by Nazmul Islam on 16/4/18.
//  Copyright © 2018 Nazmul Islam. All rights reserved.
//

import UIKit
import SnapKit

class MealTableViewCell: UITableViewCell {
    //MARK: Properties
    let mealPhoto: UIImageView = {
        let imageView = UIImageView()
        let defaultImage = UIImage(named: "meal1")
        imageView.image = defaultImage
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Meal Name"
        return label
    }()
    
    let ratingControll: RatingControl = {
        let ratingControl = RatingControl()
        ratingControl.rating = 4
        ratingControl.isUserInteractionEnabled = false
        return ratingControl
    }()
    
    //MARK: Initializtions
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Methods
    private func setUpViews() {
        self.contentView.addSubview(self.mealPhoto)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.ratingControll)
        
        self.mealPhoto.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.height.equalTo(90.0)
            make.width.equalTo(90.0)
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.left.equalTo(mealPhoto.snp.right).offset(8.0)
            make.right.equalToSuperview().inset(8.0)
            make.top.equalToSuperview().offset(8.0)
        }
        
        self.ratingControll.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.left.equalTo(mealPhoto.snp.right).offset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
    }
}
