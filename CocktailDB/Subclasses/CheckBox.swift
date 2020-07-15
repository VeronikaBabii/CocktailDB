//
//  CheckBox.swift
//  CocktailDB
//
//  Created by Veronika Babii on 14.07.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

//class CheckBox: UIButton {
//
//    let checkedImage = UIImage(named: "checked-image")! as UIImage
//    let uncheckedImage = UIImage(named: "unchecked-image")! as UIImage
//
//    var isChecked: Bool = true {
//        didSet {
//            if isChecked == true {
//                self.setImage(checkedImage, for: .normal)
//            } else {
//                self.setImage(uncheckedImage, for: .normal)
//            }
//        }
//    }
//
//    override func awakeFromNib() {
//        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
//        self.isChecked = true
//    }
//
//    @objc func buttonClicked(sender: UIButton) {
//        if sender == self {
//            if isChecked == false {
//                isChecked = true
//            } else {
//                isChecked = false
//            }
//        }
//    }
//}

class CheckBox: UIButton {
    
    override func awakeFromNib() {
        let checkedImage = UIImage(named: "checked-image")! as UIImage
        let uncheckedImage = UIImage(named: "unchecked-image")! as UIImage
        
        self.setImage(uncheckedImage, for: .normal)
        self.setImage(checkedImage, for: .selected)

        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.isSelected = true
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
             sender.isSelected = !sender.isSelected
        }
    }
}
