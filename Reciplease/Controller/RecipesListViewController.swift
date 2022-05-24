//
//  RecipesListViewController.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import UIKit

class RecipesListViewController: UIViewController {
    // MARK: - Properties
    var favoriteMode = true
    var recipesListEntities: [RecipeDetailsEntity] = []
    lazy var trashBarItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAll))
    }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var recipesListTableView: UITableView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if favoriteMode {
            recipesListEntities = FavoritesRecipes.favoriteRecipeEntities()
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
       
        return recipesListEntities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! listRecipesTableViewCell
        
        cell.configureCellEntity(recipe: recipesListEntities[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension RecipesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeDetailsStoryboard = UIStoryboard(name: "RecipeDetails", bundle: nil)
        
        guard let recipeDetailsViewController = recipeDetailsStoryboard.instantiateViewController(withIdentifier: "RecipeDetails") as? RecipeDetailsViewController else {
            return
        }
        configureViewController(recipeDetailsViewController, indexPath)
        navigationController?.pushViewController(recipeDetailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, favoriteMode  {
            deleteRecipe(indexPath)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return favoriteMode
    }
    
    private func configureViewController(_ RecipeDetailsViewController: RecipeDetailsViewController, _ indexPath: IndexPath) {
            RecipeDetailsViewController.favoritePage = favoriteMode
            RecipeDetailsViewController.recipeDetail =  recipesListEntities[indexPath.row]
    }
    
    private func deleteRecipe(_ indexPath: IndexPath) {
        CoreDataManager.shared.deleteRecipe(recipe: recipesListEntities[indexPath.row]){ result in
            switch result {
            case .success(_):
                self.presentAlertSuccess(alertMessage: "Your recipe has been removed from your favorite")
            case .failure(let error):
                self.presentAlertError(alertMessage: error.localizedDescription)
            }
        }
    }
}
