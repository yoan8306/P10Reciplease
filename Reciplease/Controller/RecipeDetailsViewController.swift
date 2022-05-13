//
//  RecipiesDetailViewController.swift
//  Reciplease
//
//  Created by Yoan on 02/05/2022.
//

import UIKit

class RecipeDetailsViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundLabelUIView: UIView!
    @IBOutlet weak var recipeDetailTableView: UITableView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var favoriteItem: UIBarButtonItem!
    @IBOutlet weak var recipeImageView: UIImageView!

    var myRecipe: RecipeDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = UIScreen.main.bounds.height
        NSLayoutConstraint.activate([recipeImageView.heightAnchor.constraint(equalToConstant: screenHeight/3)])
        favoriteItem.tintColor = #colorLiteral(red: 0.2679148018, green: 0.5845233202, blue: 0.3515217304, alpha: 1)
        initializeView()
        getImageService(recipe: myRecipe)
    }

    @IBAction func getDirectionAction() {

    }

    @IBAction func FavoriteButtonAction(_ sender: UIBarButtonItem) {
        favoriteItem.image = UIImage(systemName: "star.fill")
        addRecipe(recipe: myRecipe)
    }

    private func initializeView() {
        let gradient = CAGradientLayer()

        gradient.frame = backgroundLabelUIView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

        backgroundLabelUIView.layer.insertSublayer(gradient, at: 0)
        recipeTitle.text = myRecipe?.label
    }

    private func getImageService(recipe: RecipeDetails?) {
        toggleActivity(shown: false)
        guard let recipe = recipe, let urlImage = recipe.image else {
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

        let newRecipe = FavoritesRecipes(context: AppDelegate.viewContext)
        newRecipe.ingredientLines = recipe.ingredientLines
        newRecipe.image = recipe.image
        newRecipe.url = recipe.url
        newRecipe.label = recipe.label
        newRecipe.ingredients = recipe.ingredients?.description
        newRecipe.totalTime = recipe.totalTime ?? 0
        newRecipe.yield = recipe.yield ?? 0
        newRecipe.imageRecipe = recipe.imageRecipe
        
        do {
            try AppDelegate.viewContext.save()
            presentAlert(alertTitle: "Success 👍", alertMessage: "Add into your favorite", buttonTitle: "Ok", alertStyle: .default)
        } catch {
            presentAlert( alertTitle: "🙁", alertMessage: "Error during save. n/Try again")
        }
        
    }
}

extension RecipeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let linesCount = myRecipe?.ingredientLines?.count else {
            return 0
        }
        return linesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        guard let myRecipe = myRecipe?.ingredientLines else {
            return cell
        }

        cell.textLabel?.text = "- \(myRecipe[indexPath.row])"
        return cell
    }
}
