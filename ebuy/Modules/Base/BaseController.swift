//
//  BaseController.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/11/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit

class BaseController: UIViewController {
    
    //Vaiable
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAlert(_ ms:String){
        let alert = UIAlertController(title: nil, message:ms, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        self.present(alert, animated: true){}
    }
    //Search for RootViewController and MyTopicViewController
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchbar()
    }
    
    func hideSearchbar(){
        self.navigationItem.titleView = nil
        
        if self.navigationItem.titleView == nil{
            createRightButtonItem()
        }
    }
    
    //Action for right Button Navigation Item
    func createSearchbar(){
        self.navigationItem.titleView = self.searchController.searchBar
        
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func createRightButtonItem(){
        let buttonSearch = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(createSearchbar))
        
        self.navigationItem.rightBarButtonItem = buttonSearch
    }
    
    // Action for tap gesture
    func dismissKeyboard() {
        view.endEditing(true)
        
    }
    
    //Color for rootViewController and LeftMenuViewController
    func hexStringToUIColor (_ hex:String) -> UIColor {
        //        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercased()
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
