//
//  FilterViewController.swift
//  CocktailDB
//
//  Created by Veronika Babii on 14.07.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    var categories = [Category]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getCategories()
    }
    
    @IBAction func applyButtonClicked(_ sender: UIButton) {
        print("Filter applied")
        
        
    }
    
    func setup() {
        navigationController?.navigationBar.tintColor = UIColor.black
        applyButton.tintColor = .white
        applyButton.backgroundColor = .black
    }
    
    func getCategories() {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    self.categories = try JSONDecoder().decode(Categories.self, from: data!).drinks
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        cell.categoryLabel.text = categories[indexPath.row].strCategory
        cell.styleButton()
        
        return cell
    }
}
