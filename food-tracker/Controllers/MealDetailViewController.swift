//
//  MealDetailViewController.swift
//  food-tracker
//
//  Created by Nazmul Islam on 23/4/18.
//  Copyright © 2018 Nazmul Islam. All rights reserved.
//

import Foundation
import UIKit

protocol MealTableViewDelegate {
    func onSaveMeal(meal: Meal)
}

class MealDetailViewController: UIViewController, UINavigationControllerDelegate {
    //MARK: IBOutlets
    unowned private var mealDetailView: MealDetailView { return self.view as! MealDetailView }
    unowned private var mealNameTextField: UITextField { return self.mealDetailView.mealNameTextField }
    unowned private var mealImageView: UIImageView { return self.mealDetailView.mealImageView }
    unowned private var mealRatingControl: RatingControl { return self.mealDetailView.mealRatingControl }
    private var cancelButton = UIBarButtonItem()
    private var saveButton = UIBarButtonItem()
    
    //MARK: Properties
    var meal: Meal?
    var mealTableViewDelegate: MealTableViewDelegate?
    
    //MARK: Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        let mealDetailView = MealDetailView()
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.yellow
        scrollView.contentSize = mealDetailView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        scrollView.addSubview(mealDetailView)
        
        self.view = mealDetailView
        
        mealNameTextField.delegate = self
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(selectImageFromPhotoLibrary))
        mealImageView.addGestureRecognizer(singleTap)
        
        if let meal = self.meal {
            self.navigationItem.title = meal.name
            self.mealNameTextField.text = meal.name
            self.mealImageView.image = meal.photo
            self.mealRatingControl.rating = meal.rating
        } else {
            self.navigationItem.title = "New Meal"
        }
        
        setUpNavigationBarButtons()
        updateSaveButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark: Private Methods
    private func resignAllResponders() {
        mealNameTextField.resignFirstResponder()
    }
    
    private func updateSaveButtonState() {
        let text = mealNameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func setUpNavigationBarButtons() {
        cancelButton = {
            let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(onCancelButtonPressed))
            return barButton
        }()
        saveButton = {
            let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(onSaveButtonPressed))
            return barButton
        }()
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    private func unwindToMealList() {
        if self.presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = self.navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("Meal Detail View Controller is not inside a navigation controller")
        }
    }
    
    //MARK: Action Methods
    @objc private func onCancelButtonPressed(_ sender: UIBarButtonItem) {
        self.unwindToMealList()
    }
    
    @objc private func onSaveButtonPressed(_ sender: UIBarButtonItem) {
        print("save button pressed")
        let name = mealNameTextField.text ?? ""
        let photo = mealImageView.image
        let rating = mealRatingControl.rating
        self.meal = Meal(name: name, photo: photo, rating: rating)
        if mealTableViewDelegate != nil {
            mealTableViewDelegate?.onSaveMeal(meal: self.meal!)
        }
        self.unwindToMealList()
    }
    
    @objc private func selectImageFromPhotoLibrary() {
        print("image tapped..")
        resignAllResponders()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension MealDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateSaveButtonState()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        if !(textField.text?.isEmpty)! {
            self.navigationItem.title = textField.text
        }
    }
}

extension MealDetailViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        mealImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

