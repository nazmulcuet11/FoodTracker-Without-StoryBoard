//
//  MealService.swift
//  food-tracker
//
//  Created by Nazmul Islam on 23/4/18.
//  Copyright © 2018 Nazmul Islam. All rights reserved.
//

import Foundation
import UIKit
import os.log

class MealService {
    //MARK: Properties
    //private var meals = [Meal]()
    
    //MARK: Archiving Path
    private static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    func getSampleMeals() -> [Meal] {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        
        //meals = [meal1, meal2, meal3]
        return [meal1, meal2, meal3]
    }
    
    func saveMeals(meals: [Meal]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: self.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: self.ArchiveURL.path) as? [Meal]
    }
}
