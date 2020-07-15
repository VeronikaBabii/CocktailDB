//
//  DrinkModel.swift
//  CocktailDB
//
//  Created by Veronika Babii on 14.07.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import Foundation

struct Response:Decodable {
    var drinks: [Drink]
}

struct Drink:Decodable {
    var strDrink: String
    var strDrinkThumb: String
}
