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
        presentAlert(alertTitle: "Information", alertMessage: myRecipes.deleteAllRecipes())
        recipesListTableView.reloadData()
    }
}

// MARK: - tableView dataSource
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

// MARK: - TableView Delegate
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, showTrash  {
            presentAlert(alertTitle: "Information",alertMessage: myRecipes.deleteRecipe(index: indexPath.row))
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return showTrash
    }
}
