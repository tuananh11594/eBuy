//
//  MyTopicViewController.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/10/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyTopicController: BaseController, UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mytopic = [TopicModel]()
    var listTopics = [TopicModel]()
    
    var filteredProduct = [TopicModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "My Topic"
        //Search
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        // Table delegate and table datasouce
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadDataFirebase()
        
    }
    
    func loadDataFirebase(){
        Constants.URL.baseURL.child("Topics").observe(.value, with: { (snapshot) in
            print(snapshot.value)
            self.listTopics = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let topicDictionary = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let topic = TopicModel(key: key,dictionary: topicDictionary)
                        self.listTopics.append(topic)
                        print(topic.topicKey)
                    }
                }
            }
            for topic in self.listTopics{
                if topic.userID == FIRAuth.auth()?.currentUser?.uid {
                    self.mytopic.append(topic)
                }
            }
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredProduct = mytopic.filter({( topicModel : TopicModel) -> Bool in
            return topicModel.title!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredProduct.count
        }
        return mytopic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let topic = mytopic[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyTopicTableViewCell {
            cell.configureCell(topic)
            return cell
        }else {
            return HomeTableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = mytopic[indexPath.row]
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "ListFullController") as! ListFullController
        if let _price = topic.price{
            yourVC.price = "\(_price) Đồng"
        }
        yourVC.descriptionListFull = topic.description!
        yourVC.titleListFull = topic.title!
        yourVC.time = topic.time!
        yourVC.linkImages = topic.images!
        yourVC.phone = topic.phone!
        yourVC.address = topic.address!
        
        self.navigationController?.pushViewController(yourVC, animated: true)
    }
    
}
