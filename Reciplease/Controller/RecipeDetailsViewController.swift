//
//  RecipiesDetailViewController.swift
//  Reciplease
//
//  Created by Yoan on 02/05/2022.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var favoritePage = false
    var recipeDetail = RecipeDetailsEntity()
    
    // MARK: - IBOutlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundLabelUIView: UIView!
    @IBOutlet weak var recipeDetailTableView: UITableView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var favoriteItem: UIBarButtonItem!
    @IBOutlet weak var getDirectionButton: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteItem.tintColor = #colorLiteral(red: 0.2679148018, green: 0.5845233202, blue: 0.3515217304, alpha: 1)
        initializeView()
    }
    
    // MARK: - IBAction
    @IBAction func getDirectionAction() {
        guard let url = URL(string: (recipeDetail.url ?? "www.edamam.com")) else {
            presentAlertError(alertMessage: "We can't open recipe")
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction func FavoriteButtonAction(_ sender: UIBarButtonItem) {
        if CoreDataManager.shared.recipeAlreadyExist(url: recipeDetail.url) {
            favoriteItem.image = UIImage(systemName: "star")
            CoreDataManager.shared.deleteRecipe(recipe: recipeDetail.url) { result in
                switch result {
                case .success(_):
                    self.presentAlertSuccess(alertMessage: "You have delete recipe of your favorites")
                case .failure(let error):
                    self.presentAlertError(alertMessage: error.localizedDescription)
                }
            }
        } else {
            favoriteItem.image = UIImage(systemName: "star.fill")
            addRecipe(recipe: recipeDetail)
        }
    }
    
    
    // MARK: - Private function
    private func initializeView() {
        insertGradient()
        recipeTitle.text = recipeDetail.label ?? "No title"
        checkRecipeInFavorite(recipe: recipeDetail.url ?? "" )
        getImageService(urlImage: recipeDetail.image)
        getDirectionButton.layer.cornerRadius = getDirectionButton.frame.height/2
    }
    
    private func insertGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = backgroundLabelUIView.bounds
        backgroundLabelUIView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        backgroundLabelUIView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func checkRecipeInFavorite(recipe: String) {
        switch CoreDataManager.shared.recipeAlreadyExist(url: recipe) {
        case true:
            favoriteItem.image = UIImage(systemName: "star.fill")
        default:
            favoriteItem.image = UIImage(systemName: "star")
        }
    }
    
    private func getImageService(urlImage: String?) {
        toggleActivity(shown: false)
        guard let urlImage = urlImage else {
            return
        }
        
        ImageRecipeService.shared.getImage(link: urlImage) { [weak self] callBack in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if case .success(let image) = callBack {
                    self.recipeImageView.image = UIImage(data: image)
                } else {
                    self.recipeImageView.image = UIImage(named: "Recipes")
                }
                self.toggleActivity(shown: true)
            }
        }
    }
    
    private func toggleActivity(shown: Bool) {
        activityIndicator.isHidden = shown
    }
    
    private func addRecipe(recipe: RecipeDetailsEntity) {
        switch CoreDataManager.shared.recipeAlreadyExist(url: recipe.url) {
        case true:
            presentAlertError(alertMessage: "You have already in your favorite")
            
        case false:
            saveRecipe(recipe)
        }
    }
    
    private func saveRecipe(_ recipe: RecipeDetailsEntity) {
        switch CoreDataManager.shared.saveRecipe(recipe: recipe) {
        case true:
            presentAlertSuccess(alertMessage: "Save success 👍 you have \(FavoritesRecipes.all.count) recipes saved")
            
        case false:
            presentAlertError(alertMessage: CoreDataError.saveError.detail)
        }
    }
}

// MARK: - TableView - DataSource
extension RecipeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeDetail.ingredientLines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        guard let food = recipeDetail.ingredientLines?[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = "- \(food)"
        return cell
    }
}
