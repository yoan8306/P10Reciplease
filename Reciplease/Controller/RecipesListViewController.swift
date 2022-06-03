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
        UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAllFavorites))
    }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var recipesListTableView: UITableView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAccessibility()
        recipesListTableView.estimatedRowHeight = UITableView.automaticDimension
        if favoriteMode {
            trashBarItem.tintColor = #colorLiteral(red: 0.2679148018, green: 0.5845233202, blue: 0.3515217304, alpha: 1)
            navigationItem.rightBarButtonItem = trashBarItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshFavorites()
        recipesListTableView.reloadData()
        if recipesListEntities.isEmpty {
            initializeTableIsEmpty()
        } else {
            recipesListTableView.backgroundView = nil
        }
    }
    
    // MARK: - IBAction
    
    @objc func deleteAllFavorites() {
        CoreDataManager.shared.deleteAllRecipes { [weak self] result in
            switch result {
            case .success(_):
                presentAlertSuccess(alertMessage: "You have delete all recipes")
                self?.initializeTableIsEmpty()
            case .failure(let error):
                presentAlertError(alertMessage: error.localizedDescription)
            }
            self?.refreshFavorites()
            self?.recipesListTableView.reloadData()
        }
    }
    
    // MARK: - private function
    private func refreshFavorites() {
        if favoriteMode {
            recipesListEntities = CoreDataManager.shared.getFavoritesRecipes().asEntities()
            if recipesListEntities.isEmpty {
                initializeTableIsEmpty()
            }
        }
    }
    
    private func initializeAccessibility() {
        trashBarItem.accessibilityHint = "Delete all favorites recipes"
    }
    
    private func initializeTableIsEmpty() {
        let backgroundImage = UIImage(systemName: "star.slash")?.withTintColor(#colorLiteral(red: 0.2679148018, green: 0.5845233202, blue: 0.3515217304, alpha: 1))
        let image = UIImageView(image: backgroundImage)
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.2679148018, green: 0.5845233202, blue: 0.3515217304, alpha: 1)
        recipesListTableView.backgroundView = image
        recipesListTableView.accessibilityHint = "You don't have favorite recipe"
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
        
        InitializeAccessibilityHintCell(cell)
        
        return cell
    }
    
    private func InitializeAccessibilityHintCell(_ cell: listRecipesTableViewCell) {
        let actionHintSearchMode = "Click on cell for show details"
        let actionHintFavoriteMode = "Click on recipe for show details, or swipe right to left for delete this"
        let HintAccessibility = favoriteMode ? actionHintFavoriteMode : actionHintSearchMode
        
        cell.accessibilityHint = HintAccessibility
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
        if editingStyle == .delete, favoriteMode {
            deleteRecipe(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return favoriteMode
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - private functions
    private func configureViewController(_ RecipeDetailsViewController: RecipeDetailsViewController, _ indexPath: IndexPath) {
        RecipeDetailsViewController.recipeDetail =  recipesListEntities[indexPath.row]
    }
    
    private func deleteRecipe(_ indexPath: IndexPath) {
        CoreDataManager.shared.deleteRecipe(recipe: recipesListEntities[indexPath.row]) { [weak self] result in
            switch result {
            case .success(_):
                self?.presentAlertSuccess(alertMessage: "Your recipe has been removed from your favorite")
            case .failure(let error):
                self?.presentAlertError(alertMessage: error.localizedDescription)
            }
            self?.refreshFavorites()
            self?.recipesListTableView.reloadData()
        }
    }
}
