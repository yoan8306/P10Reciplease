//
//  RecipiesDetailViewController.swift
//  Reciplease
//
//  Created by Yoan on 02/05/2022.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
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
    }
    
    
    
    
    @IBAction func getDirectionAction() {

    }
    
 
    @IBAction func FavoriteButtonAction(_ sender: UIBarButtonItem) {
        favoriteItem.image = UIImage(systemName: "star.fill")
        presentAlert(alertTitle: "Success 👍", alertMessage: "Add into your favorite", buttonTitle: "Ok", alertStyle: .default)
    }
    
    private func initializeView() {
        recipeTitle.text = myRecipe?.label
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
