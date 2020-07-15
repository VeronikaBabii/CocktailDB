//
//  ViewController.swift
//  CocktailDB
//
//  Created by Veronika Babii on 14.07.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var drinks = [Drink]()
    var categories = [Category]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getCategories()
        
        getDrinksFrom(category: "Cocoa")
    }
    
    func setup() {
        navigationController?.navigationBar.tintColor = UIColor.black
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
                    print(self.categories)
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getDrinksFrom(category: String) {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(category)")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    self.drinks = try JSONDecoder().decode(Drinks.self, from: data!).drinks
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(self.drinks)
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].strCategory
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell") as! DrinkCell
        
        cell.drinkName.text = drinks[indexPath.row].strDrink
        
        let url = drinks[indexPath.row].strDrinkThumb
        cell.drinkImage.downloaded(from: url)
        
        return cell
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
