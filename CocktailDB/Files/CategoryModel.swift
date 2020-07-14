//
//  CategoryModel.swift
//  CocktailDB
//
//  Created by Veronika Babii on 14.07.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import Foundation

struct Categories:Decodable {
    var drinks: [Category]
}

struct Category:Decodable {
    var strCategory: String
}
