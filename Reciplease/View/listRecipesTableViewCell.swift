//
//  listRecipesTableViewCell.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import UIKit

class listRecipesTableViewCell: UITableViewCell {
// MARK: - IBOutlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundLabelUIView: UIView!
    @IBOutlet weak var recipesTitle: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsList: UILabel!
    @IBOutlet weak var scoreRecipe: UILabel!
    @IBOutlet weak var totalTime: UILabel!

// MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

// MARK: - Function
    func configureCellEntity(recipe: RecipeDetailsEntity, favoriteMode: Bool) {
        getImageService(recipe.image ?? "")
        configureTextCell(recipe: recipe)
        initializeAccessibilityHintCell(favoriteMode: favoriteMode)
        addGradient()
    }

// MARK: - Private functions
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = backgroundLabelUIView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

        backgroundLabelUIView.backgroundColor = UIColor.clear
        backgroundLabelUIView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        backgroundLabelUIView.layer.insertSublayer(gradient, at: 0)
    }

    private func getImageService(_ urlImage: String) {
        toggleActivityIndicator(shown: true)
        
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

                self.toggleActivityIndicator(shown: false)
            }
        }
    }

    private func initializeAccessibilityHintCell(favoriteMode: Bool) {
        let actionHintSearchMode = "Click on cell for show details"
        let actionHintFavoriteMode = "Click on recipe for show details, or scroll with three fingers right to left for delete this"
        let hintAccessibility = favoriteMode ? actionHintFavoriteMode : actionHintSearchMode

        accessibilityHint = hintAccessibility
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    private func configureTextCell(recipe: RecipeDetailsEntity) {
        recipesTitle.text = recipe.label ?? "No title"
        ingredientsList.text = recipe.ingredients ?? "No list"
        totalTime.text = "\(String(Int(recipe.totalTime ?? 0))) min ⏲"
        scoreRecipe.text = "\(String(recipe.yield ?? 0))K 👍"
    }
}
