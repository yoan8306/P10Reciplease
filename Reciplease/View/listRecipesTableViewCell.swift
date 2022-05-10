//
//  listRecipesTableViewCell.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import UIKit

class listRecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var recipesTitle: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsList: UILabel!
    @IBOutlet weak var scoreRecipe: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(recipe: RecipesDTO?, index: Int) {
        guard let recipe = recipe  else {
            return
        }
        
        let urlImage = recipe.hits?[index].recipe?.image
        
        guard let urlImage = urlImage else {
            return
        }
    
        ImageRecipeService.shared.getImage(link: urlImage) { [weak self] callBack in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if case .success(let image) = callBack {
                    self.imageRecipe.image = UIImage(data: image)
                }
            }
        }
        configureTextCell(recipe: recipe, index: index)
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
