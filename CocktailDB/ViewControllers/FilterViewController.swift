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
    
    var datas = [[String : Any]]()
    
    var selectedCatArr = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getCategories()
    }
    
    @IBAction func applyButtonClicked(_ sender: UIButton) {
        
        var selectedCatgry = [String]()
        for i in 0..<datas.count
        {
            let rowVal = datas[i]
            if rowVal["status"] as! String == "1"{
                selectedCatgry.append(rowVal["name"] as! String)
            }
        }
        print(selectedCatgry)
        selectedCatArr = selectedCatgry
        print(selectedCatArr)
    }
    
    func getCategories() {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    self.categories = try JSONDecoder().decode(Categories.self, from: data!).drinks
                    
                    for i in 0..<self.categories.count {
                        self.datas.append(["name":self.categories[i].strCategory, "status":"1"])
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func setup() {
        navigationController?.navigationBar.tintColor = UIColor.black
        applyButton.tintColor = .white
        applyButton.backgroundColor = .black
    }
    
    @objc func subscribeTapped(_ sender: UIButton){
        var sel = datas[sender.tag]
        datas.remove(at: sender.tag)
        
        if sel["status"] as! String == "1"{
            sel.updateValue("0", forKey: "status")
        }else{
            sel.updateValue("1", forKey: "status")
        }
        
        datas.insert(sel, at: sender.tag)
        tableView.reloadData()
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return categories.count
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        cell.styleButton()
        
        let val = datas[indexPath.row]
        cell.categoryLabel.text = (val["name"] as! String)
        
        if (val["status"] as! String) == "1"{
            cell.checkBoxButton.setImage(UIImage(systemName: "checked-image"), for: .normal)
        }else {
            cell.checkBoxButton.setImage(UIImage(systemName: "unchecked-image"), for: .normal)
        }
        cell.checkBoxButton.addTarget(self, action: #selector(subscribeTapped(_:)), for: .touchUpInside)
        cell.checkBoxButton.tag = indexPath.row
        
        return cell
    }
}
