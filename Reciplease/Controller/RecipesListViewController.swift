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
    
//    private func addShadow() {
//        UIView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
//        UIView.layer.shadowRadius = 2.0
//        UIView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        UIView.layer.shadowOpacity = 2.0
//    }

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

extension RecipesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let RecipeDetailsStoryboard = UIStoryboard(name: "RecipeDetails", bundle: nil)
        guard let RecipeDetailsViewController = RecipeDetailsStoryboard.instantiateViewController(withIdentifier: "RecipeDetails") as? RecipeDetailsViewController else {
            return
        }
        RecipeDetailsViewController.myRecipe = recipesList.listIngredient[indexPath.row]
        navigationController?.pushViewController(RecipeDetailsViewController, animated: true)
    }
}
