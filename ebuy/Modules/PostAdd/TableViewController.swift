//
//  TableViewController.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/12/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import UIKit
//protocol for delegate
protocol CategoryControllerDelegate : class {
    func didSelectCategory(_ mcategory: String)
}

class CategoryController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var Category: [String] = ["BikeCar", "Computer","Fashion", "House", "Mobile","Pet","Sport","Other"]
    var selectedCat :String?
    //for delegate. in delegate only use weak
    weak var delegate : CategoryControllerDelegate?
    
    var currentcategory: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Category.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel!.text = self.Category[indexPath.row]
        
        if selectedCat == Category[indexPath.row] {
            cell.accessoryType = .checkmark}
        else{
            cell.accessoryType = .none
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.didSelectCategory(self.Category[indexPath.row])
        
        //        selectedCat = self.Category[indexPath.row]
        let section = indexPath.section
        let numberOfRows = tableView.numberOfRows(inSection: section)
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
