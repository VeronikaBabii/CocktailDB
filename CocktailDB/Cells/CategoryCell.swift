//
//  CategoryCell.swift
//  CocktailDB
//
//  Created by Veronika Babii on 14.07.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkBoxButton: CheckBox!
    
    func styleButton() {
        checkBoxButton.tintColor = .black
    }
}
