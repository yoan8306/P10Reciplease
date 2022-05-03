//
//  RecipesListViewController.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import UIKit

class RecipesListViewController: UIViewController {
    
    var recipesList = IngredientsList()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.listIngredient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! listRecipesTableViewCell
        let recipesTitle = recipesList.listIngredient[indexPath.row]
        
        cell.configureCell(titleRecipes: recipesTitle)
        return cell
    }
    
    
}
