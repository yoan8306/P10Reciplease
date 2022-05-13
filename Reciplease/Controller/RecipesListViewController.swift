//
//  RecipesListViewController.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import UIKit

class RecipesListViewController: UIViewController {

    var recipesList: RecipesDTO?
    var showTrash = true
    var myRecipes = FavoritesRecipes.all
    lazy var trashBarItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAll))
    }()
    
    @IBOutlet weak var recipesListTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if showTrash {
            navigationItem.rightBarButtonItem = trashBarItem
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myRecipes = FavoritesRecipes.all
        recipesListTableView.reloadData()
    }

    @objc func deleteAll() {
        trashBarItem.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        presentAlert(alertMessage: "You have delete all")
    }
}

extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberSection = 0
        if showTrash {
            numberSection = myRecipes.count
        } else {
            guard let recipesList = recipesList?.hits else {
                return 0
            }
            numberSection = recipesList.count
        }
       return numberSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! listRecipesTableViewCell
        if showTrash {
            cell.configureFavoriteCell(recipe: myRecipes, index: indexPath.row)
        } else {
            cell.configureCell(recipe: recipesList, index: indexPath.row)
        }
        return cell
    }
}

extension RecipesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let RecipeDetailsStoryboard = UIStoryboard(name: "RecipeDetails", bundle: nil)

        guard let RecipeDetailsViewController = RecipeDetailsStoryboard.instantiateViewController(withIdentifier: "RecipeDetails") as? RecipeDetailsViewController else {
            return
        }
        if showTrash {
            RecipeDetailsViewController.favoritePage = true
            RecipeDetailsViewController.favoriteRecipes = myRecipes[indexPath.row]
        } else {
            RecipeDetailsViewController.favoritePage = false
            RecipeDetailsViewController.myRecipe = recipesList?.hits?[indexPath.row].recipe
        }
        navigationController?.pushViewController(RecipeDetailsViewController, animated: true)
    }
}
