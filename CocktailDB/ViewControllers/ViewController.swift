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
    var categories = [OneCategory]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        loadAllCategories()
        
        //var selectedCategoriesArr: [String] = ["Cocoa", "Shot"]
        
//        getCategories { [weak self] in
//            self?.getDrinksFrom(category: "Cocoa")
//            self?.getDrinksFrom(category: "Shot")
//        }
        
    }
    
    func loadAllCategories() {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                let categoryNames = (result["drinks"] as! [[String:String]]).map{$0["strCategory"]!}
                let group = DispatchGroup()
                
                for category in categoryNames {
                    let categoryURLString = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(category)"
                        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    let categoryURL = URL(string: categoryURLString)!
                    
                    group.enter()
                    let categoryTask = URLSession.shared.dataTask(with: categoryURL) { (categoryData, _, categoryError) in
                        
                        defer {
                            group.leave()
                        }
                        
                        if let categoryError = categoryError {
                            print(categoryError)
                            return
                        }
                        
                        do {
                            let drinks = try JSONDecoder().decode(Response.self, from: categoryData!).drinks
                            self.categories.append(OneCategory(name: category, drinks: drinks))
                        } catch {
                            print(error)
                        }
                    }
                    categoryTask.resume()
                }
                
                group.notify(queue: .main) {
                    self.tableView.reloadData()
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getCategories(completion: @escaping () -> Void) {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error { print(error); return }
            do {
                let result = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                let categoryNames = result["drinks"] as! [[String:String]]
                self.categories = categoryNames.map{ OneCategory(name: $0["strCategory"]!, drinks:[])}
                completion()
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getDrinksFrom(category: String) {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(category)")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error { print(error); return }
            do {
                let drinks = try JSONDecoder().decode(Response.self, from: data!).drinks
                guard let index = self.categories.firstIndex(where: {$0.name == category}) else { return }
                self.categories[index].drinks = drinks
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func setup() {
        navigationController?.navigationBar.tintColor = UIColor.black
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell") as! DrinkCell
        
        let category = categories[indexPath.section]
        let drink = category.drinks[indexPath.row]
        cell.drinkName.text = drink.strDrink
        
        let url = drink.strDrinkThumb
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
