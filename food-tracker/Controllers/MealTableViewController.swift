//
//  MealTableViewController.swift
//  food-tracker
//
//  Created by Nazmul Islam on 16/4/18.
//  Copyright © 2018 Nazmul Islam. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    //MARK: Outlets
    private var addMealButton = UIBarButtonItem()
    private var editButton = UIBarButtonItem()
    
    //MARK: Properties
    private var meals = [Meal]()
    private let mealService = MealService()
    
    //MARK: Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MealTableViewCell.self, forCellReuseIdentifier: "mealTableViewCell")
        if let meals = mealService.loadMeals(), meals.count > 0 {
            self.meals = meals
        } else {
            self.meals = mealService.getSampleMeals()
        }
        self.navigationItem.title = "My Meals"
        self.setUpNavigationBarButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private Methods
    private func setUpNavigationBarButtons() {
        addMealButton = {
            let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(onAddButtonPressed))
            return barButton
        }()
        editButton = editButtonItem
        self.navigationItem.rightBarButtonItem = addMealButton
        self.navigationItem.leftBarButtonItem = editButton
    }
    
    //MARK: Action Methods
    @objc private func onAddButtonPressed(_ sender: UIBarButtonItem) {
        print("add button pressed .. ")
        let mealDetailVC = MealDetailViewController()
        mealDetailVC.mealTableViewDelegate = self
        mealDetailVC.modalPresentationStyle = .fullScreen
        let navViewController: UINavigationController = UINavigationController(rootViewController: mealDetailVC)
        //self.navigationController?.pushViewController(mealDetailVC, animated: true)
        self.present(navViewController, animated: true, completion: nil)
    }
}

//MARK: Tableview Delegate Methods
extension MealTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = self.tableView.dequeueReusableCell(withIdentifier: "mealTableViewCell", for: indexPath) as? MealTableViewCell else {
            fatalError("Dequed cell is not an instance of meal table view cell")
        }
        
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.mealPhoto.image = meal.photo
        cell.ratingControll.rating = meal.rating
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeal = meals[indexPath.row]
        let mealDetailVC = MealDetailViewController()
        mealDetailVC.meal = selectedMeal
        mealDetailVC.mealTableViewDelegate = self
        self.navigationController?.pushViewController(mealDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            mealService.saveMeals(meals: self.meals)
        }
    }
    
}

extension MealTableViewController: MealTableViewDelegate {
    func onSaveMeal(meal: Meal) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            print("Selected item no \(selectedIndexPath.row + 1)")
            meals[selectedIndexPath.row] = meal
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            print("This is a new item")
            let newIndexPath = IndexPath(row: meals.count, section: 0)
            meals.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        mealService.saveMeals(meals: self.meals)
        print(meal.name)
        print(meal.rating)
    }
}
