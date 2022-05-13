//
//  RecipesListViewController.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import UIKit

class RecipesListViewController: UIViewController {

    @IBOutlet weak var recipesListTableView: UITableView!
    var recipesList: RecipesDTO?
    var showTrash = true

    lazy var trashBarItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAll))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if showTrash {
            navigationItem.rightBarButtonItem = trashBarItem
        }
    }

    @objc func deleteAll() {
        trashBarItem.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        presentAlert(alertMessage: "You have delete all")
    }
}

extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipesList = recipesList?.hits else {
            return 0
        }
        return recipesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! listRecipesTableViewCell

        cell.configureCell(recipe: recipesList, index: indexPath.row)
        return cell
    }

}

extension RecipesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let RecipeDetailsStoryboard = UIStoryboard(name: "RecipeDetails", bundle: nil)

        guard let RecipeDetailsViewController = RecipeDetailsStoryboard.instantiateViewController(withIdentifier: "RecipeDetails") as? RecipeDetailsViewController else {
            return
        }

        RecipeDetailsViewController.myRecipe = recipesList?.hits?[indexPath.row].recipe
        navigationController?.pushViewController(RecipeDetailsViewController, animated: true)
    }
}
