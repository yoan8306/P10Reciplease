//
//  RecipiesDetailViewController.swift
//  Reciplease
//
//  Created by Yoan on 02/05/2022.
//

import UIKit

class RecipeDetailsViewController: UIViewController {

// MARK: - Properties
    var myRecipe: RecipeDetails?
    var favoritePage = false
    var favoriteRecipes = FavoritesRecipes()

// MARK: - IBOutlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundLabelUIView: UIView!
    @IBOutlet weak var recipeDetailTableView: UITableView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var favoriteItem: UIBarButtonItem!
    @IBOutlet weak var recipeImageView: UIImageView!

// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = UIScreen.main.bounds.height
        NSLayoutConstraint.activate([recipeImageView.heightAnchor.constraint(equalToConstant: screenHeight/3)])
        favoriteItem.tintColor = #colorLiteral(red: 0.2679148018, green: 0.5845233202, blue: 0.3515217304, alpha: 1)
        initializeView()
    }

// MARK: - IBAction
    @IBAction func getDirectionAction() {
        
    }
    
    @IBAction func FavoriteButtonAction(_ sender: UIBarButtonItem) {
        favoriteItem.image = UIImage(systemName: "star.fill")
        addRecipe(recipe: myRecipe)
    }

// MARK: - Private function
    private func initializeView() {
        let gradient = CAGradientLayer()
        
        if favoritePage {
            getImageService(urlImage: favoriteRecipes.image)
            favoriteItem.image = UIImage(systemName: "star.fill")
        } else {
            checkRecipe(recipe: myRecipe)
            getImageService(urlImage: myRecipe?.image)
        }
        
        gradient.frame = backgroundLabelUIView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        backgroundLabelUIView.layer.insertSublayer(gradient, at: 0)
        recipeTitle.text = myRecipe?.label
    }
    
    private func checkRecipe(recipe: RecipeDetails?) {
        guard let myRecipe = myRecipe else {
            return
        }
       
        if favoriteRecipes.recipeAlreadyExist(url: myRecipe.url) {
            favoriteItem.image = UIImage(systemName: "star.fill")
        }
        else {
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
    
    private func addRecipe(recipe: RecipeDetails?) {
        guard let recipe = recipe else {
            return
        }
        
        if favoriteRecipes.recipeAlreadyExist(url: recipe.url) {
            presentAlert(alertMessage: "You have already in your favorite")
        } else {
            
            switch favoriteRecipes.saveRecipe(recipe: recipe) {
            case true:
                presentAlert(alertTitle: "Success 👍", alertMessage: "Add into your favorite \nYou have \(FavoritesRecipes.all.count) recipes saved")
            case false:
                presentAlert( alertTitle: "🙁", alertMessage: "Error during save. n/Try again")
            }
        }
    }
}

// MARK: - TableView - DataSource
extension RecipeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var linesCount = 0
        if favoritePage {
            linesCount = favoriteRecipes.ingredientLines?.count ?? 0
        } else {
            linesCount = myRecipe?.ingredientLines?.count ?? 0
        }
        return linesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        if favoritePage {
            guard let favoriteDetail = favoriteRecipes.ingredientLines else {
                return cell
            }
            cell.textLabel?.text = "- \(favoriteDetail[indexPath.row])"
        } else {
            guard let myRecipe = myRecipe?.ingredientLines else {
                return cell
            }
            cell.textLabel?.text = "- \(myRecipe[indexPath.row])"
        }
        return cell
    }
}
