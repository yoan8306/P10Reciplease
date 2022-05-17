//
//  SearchRecipeViewController.swift
//  Reciplease
//
//  Created by Yoan on 29/04/2022.
//

import UIKit

class SearchRecipeViewController: UIViewController {
    var listIngredients = IngredientsList()

// MARK: - IBOutlet
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var searchRecipeButton: UIButton!
    @IBOutlet weak var ListIngredientsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    

// MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }

// MARK: - IBAction
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientsTextField.resignFirstResponder()
    }

    @IBAction func addIngredientsActionButton() {
        if listIngredients.addIngredient(ingredientList: ingredientsTextField.text ?? "") {
            ingredientsTextField.text = ""
            ingredientsTextField.resignFirstResponder()
            ListIngredientsTableView.reloadData()
        } else {
            presentAlert(alertMessage: "You can separate ingredient list with \",\"\nTry again 😉")
        }
    }

    @IBAction func clearIngredientsActionButton() {
        listIngredients.clearListIngredient()
        ListIngredientsTableView.reloadData()
    }

    @IBAction func searchRecipesActionButton() {
        callRecipes(ingredients: listIngredients.returnIngredientList())
    }

// MARK: - privates functions
    private func callRecipes(ingredients: String) {
        showActivityIndicator(shown: true)
        RecipeService.shared.getTheRecipes(ingredients: ingredients) { [weak self] callBack in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                switch callBack {
                case .success(let recipes):
                    self.transferRecipesToRecipesListViewController(recipesList: recipes)
                case .failure(let error):
                    self.presentAlert(alertMessage: error.localizedDescription)
                }
                self.showActivityIndicator(shown: false)
            }
        }
    }

    private func transferRecipesToRecipesListViewController(recipesList: RecipesDTO) {
        let recipesListStoryboard = UIStoryboard(name: "RecipesList", bundle: nil)

        guard let recipesListViewController = recipesListStoryboard.instantiateViewController(withIdentifier: "RecipesList") as? RecipesListViewController else {
         return
        }

        recipesListViewController.recipesList = recipesList
        recipesListViewController.showTrash = false
        navigationController?.pushViewController(recipesListViewController, animated: true)
    }

    private func showActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        searchRecipeButton.isHidden = shown
    }
    
    private func initializeView() {
        searchRecipeButton.layer.cornerRadius = searchRecipeButton.frame.height/2
        addButton.layer.cornerRadius = addButton.frame.height/2
        clearButton.layer.cornerRadius = clearButton.frame.height/2
       
    }
}

// MARK: - table view data source
extension SearchRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIngredients.listIngredient.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredient = listIngredients.listIngredient[indexPath.row]

        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = "- " + ingredient
            content.textProperties.font = UIFont(name: "Chalkduster", size: 17)!
            content.textProperties.color = .white
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = ingredient
        }
        return cell
    }
}
// MARK: - TableView delegate
extension SearchRecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listIngredients.removeIngredient(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Textfield delegate
extension SearchRecipeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredientsActionButton()
        return true
    }
}
