//
//  listRecipesTableViewCell.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import UIKit

class listRecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundLabelUIView: UIView!
    @IBOutlet weak var recipesTitle: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsList: UILabel!
    @IBOutlet weak var scoreRecipe: UILabel!
    @IBOutlet weak var totalTime: UILabel!

    var responseReceived = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureFavoriteCell(recipe: [FavoritesRecipes], index: Int) {
        guard let urlImage = recipe[index].image else {
            return
        }
        recipesTitle.text = recipe[index].label
        ingredientsList.text = recipe[index].ingredientLines?.joined(separator: ", ")
        totalTime.text = "\(String(recipe[index].totalTime)) ⏲"
        scoreRecipe.text = "\(String(recipe[index].yield)) 👍"
        getImageService(urlImage)
    }
    

    func configureCell(recipe: RecipesDTO?, index: Int) {
        guard let recipe = recipe, let urlImage = recipe.hits?[index].recipe?.image  else {
            return
        }
        addGradient()
        getImageService(urlImage)
        configureTextCell(recipe: recipe, index: index)
    }

   private func addGradient() {
    let gradient = CAGradientLayer()
    gradient.frame = backgroundLabelUIView.bounds
    gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
       backgroundLabelUIView.backgroundColor = UIColor.clear
       backgroundLabelUIView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
       backgroundLabelUIView.layer.insertSublayer(gradient, at: 0)
}

    private func getImageService(_ urlImage: String) {
        ImageRecipeService.shared.getImage(link: urlImage) { [weak self] callBack in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if case .success(let image) = callBack {
                    self.imageRecipe.image = UIImage(data: image)
                } else {
                    self.imageRecipe.image = UIImage(named: "Recipes")
                }
                self.toggleActivityIndicator()
            }
        }
    }

    private func toggleActivityIndicator() {
        activityIndicator.isHidden = true
    }

    private func configureTextCell(recipe: RecipesDTO, index: Int) {
        recipesTitle.text = recipe.hits?[index].recipe?.label ?? "No title"
        ingredientsList.text = getIngredients(recipe: recipe, index: index)
        totalTime.text = "\(String(recipe.hits?[index].recipe?.totalTime ?? 0)) ⏲"
        scoreRecipe.text = "\(String(recipe.hits?[index].recipe?.yield ?? 0)) 👍"

    }

    private func getIngredients(recipe: RecipesDTO, index: Int) -> String {
        var listIngredients: [String] = []
        guard let ingredients = recipe.hits?[index].recipe?.ingredients else {
            return "nul"
        }
            for ingredient in ingredients {
                listIngredients.append(ingredient.food ?? "N/A")
            }

        return listIngredients.joined(separator: ", ")
    }
}
