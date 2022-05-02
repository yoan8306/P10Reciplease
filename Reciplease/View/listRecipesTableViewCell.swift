//
//  listRecipesTableViewCell.swift
//  Reciplease
//
//  Created by Yoan on 30/04/2022.
//

import UIKit

class listRecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var recipesTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(titleRecipes: String) {
        recipesTitle.text = titleRecipes
    }

}
