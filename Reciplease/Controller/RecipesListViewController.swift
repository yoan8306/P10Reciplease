//
//  RecipesListViewController.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import UIKit

class RecipesListViewController: UIViewController {
// MARK: - Properties
    var recipesList: RecipesDTO?
    var showTrash = true
    var myRecipes = FavoritesRecipes()
    lazy var trashBarItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAll))
    }()

// MARK: - IBOutlet
    @IBOutlet weak var recipesListTableView: UITableView!
   
// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if showTrash {
            navigationItem.rightBarButtonItem = trashBarItem
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipesListTableView.reloadData()
    }
// MARK: - IBAction
    @objc func deleteAll() {
        for recipe in FavoritesRecipes.all {
            AppDelegate.viewContext.delete(recipe)
        }
        do {
            try AppDelegate.viewContext.save()
            presentAlert(alertTitle: "❌", alertMessage: "You have delete all 🗑")
        } catch {
            presentAlert(alertMessage: "An error exist. We don't can remove all")
        }
        recipesListTableView.reloadData()
    }
}

extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberSection = 0
        if showTrash {
            numberSection = FavoritesRecipes.all.count
            if case numberSection = 0 {
                presentAlert(alertMessage: "You have no favorite... 🥺")
            }
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
            cell.configureFavoriteCell(recipe: FavoritesRecipes.all, index: indexPath.row)
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
            RecipeDetailsViewController.favoriteRecipes = FavoritesRecipes.all[indexPath.row]
        } else {
            RecipeDetailsViewController.favoritePage = false
            RecipeDetailsViewController.myRecipe = recipesList?.hits?[indexPath.row].recipe
        }
        navigationController?.pushViewController(RecipeDetailsViewController, animated: true)
    }
}
