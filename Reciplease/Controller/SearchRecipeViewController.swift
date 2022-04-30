//
//  SearchRecipeViewController.swift
//  Reciplease
//
//  Created by Yoan on 29/04/2022.
//

import UIKit

class SearchRecipeViewController: UIViewController {
    var listIngredients = IngredientsList()
    
// MARK: - IBOutlet
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ListIngredientsTableView: UITableView!
    
// MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
// MARK: - IBAction
    @IBAction func addIngredientsActionButton() {
        guard let listIngredient = ingredientsTextField.text else {
            return
        }
        listIngredients.addIngredient(ingredientList: listIngredient)
        ListIngredientsTableView.reloadData()
    }
    
    @IBAction func clearIngredientsActionButton() {
        
    }
    
    @IBAction func searchRecipesActionButton() {
    }
    
    
}

extension SearchRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIngredients.listIngredient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredient = listIngredients.listIngredient[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = "- " + ingredient
            content.textProperties.font = UIFont(name: "Chalkduster", size: 17)!
            content.textProperties.color = .white
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = ingredient
        }

        return cell
    }
    
    
}
