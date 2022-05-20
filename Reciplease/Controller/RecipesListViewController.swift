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
        CoreDataManager.shared.deleteAllRecipes { result in
            switch result {
            case .success(_):
                presentAlertSuccess(alertMessage: "You have delete all recipes")
            case .failure(let error):
                presentAlertError(alertMessage: error.localizedDescription)
            }
        }
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
                presentAlertError(alertMessage: "You have no favorite... 🥺")
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
        var myRecipe = RecipeDetailsEntity()
        
        switch showTrash {
        case true:
            myRecipe = FavoritesRecipes.favoriteRecipeEntities()[indexPath.row]
        case false:
            myRecipe = recipesList?.hits?[indexPath.row].recipe?.asEntity() ?? RecipeDetailsEntity()
        }

        cell.configureCellEntity(recipe: myRecipe)
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
        configureViewController(RecipeDetailsViewController, indexPath)
        navigationController?.pushViewController(RecipeDetailsViewController, animated: true)
    }

    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, showTrash  {
            deleteRecipe(indexPath)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return showTrash
    }
    
    private func configureViewController(_ RecipeDetailsViewController: RecipeDetailsViewController, _ indexPath: IndexPath) {
        switch showTrash {
        case true:
            RecipeDetailsViewController.favoritePage = true
            RecipeDetailsViewController.recipeDetail =  FavoritesRecipes.favoriteRecipeEntities()[indexPath.row]
        case false:
            RecipeDetailsViewController.favoritePage = false
            RecipeDetailsViewController.recipeDetail = recipesList?.hits?[indexPath.row].recipe?.asEntity() ?? RecipeDetailsEntity()
        }
    }
    
    private func deleteRecipe(_ indexPath: IndexPath) {
        let recipeSelected = FavoritesRecipes.all[indexPath.row].url
        CoreDataManager.shared.deleteRecipe(recipe: recipeSelected){ result in
            switch result {
            case .success(_):
                self.presentAlertSuccess(alertMessage: "Your recipe has been removed from your favorite")
            case .failure(let error):
                self.presentAlertError(alertMessage: error.localizedDescription)
            }
        }
    }
}
