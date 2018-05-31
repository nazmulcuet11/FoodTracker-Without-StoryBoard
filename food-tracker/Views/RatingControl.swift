//
//  RatingControll.swift
//  food-tracker
//
//  Created by Nazmul Islam on 18/4/18.
//  Copyright © 2018 Nazmul Islam. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating: Int = 0 {
        didSet {
            self.updateButtonSelectionStates()
        }
    }
    var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            self.setupButtons()
        }
    }
    var starCount: Int = 5 {
        didSet {
            self.setupButtons()
        }
    }
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.spacing = 8.0
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Action Methods
    @objc private func ratingButtonTapped(button: UIButton) {
        print("rating button tapped 👍")
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        for button in ratingButtons {
            self.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<self.starCount {
            let ratingButton: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: self.starSize.height).isActive = true
                button.widthAnchor.constraint(equalToConstant: self.starSize.width).isActive = true
                button.setImage(emptyStar, for: .normal)
                button.setImage(filledStar, for: .selected)
                button.setImage(highlightedStar, for: .highlighted)
                button.setImage(highlightedStar, for: [.highlighted, .selected])
                
                button.addTarget(self, action: #selector(self.ratingButtonTapped(button:)), for: UIControlEvents.touchUpInside)
                return button
            }()
            
            self.addArrangedSubview(ratingButton)
            self.ratingButtons.append(ratingButton)
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
