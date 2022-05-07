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
    
    var myRecipe = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = UIScreen.main.bounds.height
        NSLayoutConstraint.activate([recipeImageView.heightAnchor.constraint(equalToConstant: screenHeight/3)])
        favoriteItem.tintColor = #colorLiteral(red: 0.2679148018, green: 0.5845233202, blue: 0.3515217304, alpha: 1)
    }
    
    
    @IBAction func getDirectionAction() {

    }
    
 
    @IBAction func FavoriteButtonAction(_ sender: UIBarButtonItem) {
        favoriteItem.image = UIImage(systemName: "star.fill")
        presentAlert(alertTitle: "Success 👍", alertMessage: "Add into your favorite", buttonTitle: "Ok", alertStyle: .default)
    }
}

extension RecipeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        cell.textLabel?.text = myRecipe
        return cell
    }
    
}
