//
//  HomeViewController.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 6/6/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import Google
import GoogleSignIn
import Firebase

class HomeController: BaseController,UITableViewDataSource,UITableViewDelegate,MenuDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    // MARK: - Valiable

    var listTopics = [TopicModel]()
    
    var topics = [TopicModel]()
    
    var filteredTopic = [TopicModel]()
    
    var category = [String]()
    
    var y = 42
    
    var height = 3
    
    
    // MARK: - Button
    @IBOutlet weak var scrollHorizontal: UIView!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var viewHomeTableScroll: UIView!
    
    //Set Constraint left of View Home
    
    @IBOutlet weak var coverBackground: UIView!
    
    @IBOutlet weak var layoutConstraintLeft: NSLayoutConstraint!
    
    @IBOutlet weak var viewMenu: UIView!
    
    
    @IBAction func panGesture(_ sender: AnyObject) {
        self.moveMenuLef()
    }
    
    @IBOutlet weak var viewScrollview: UIView!
    
    @IBAction func btnAll(_ sender: AnyObject) {
        self.topics = listTopics
        tableView.reloadData()
        self.scrollHorizontal.frame = CGRect(x:18 , y: y, width: 30, height: height)
    }
    
    @IBAction func btnHouse(_ sender: AnyObject) {
        self.topics = []
        for topic in listTopics {
            if topic.category == "House" {
                self.topics.append(topic)
            }
        }
        tableView.reloadData()
        self.scrollHorizontal.frame = CGRect(x:83 , y: y, width: 50, height: height)
    }
    
    @IBAction func btnComputer(_ sender: AnyObject) {
        self.topics = []
        for topic in listTopics {
            if topic.category == "Computer" {
                self.topics.append(topic)
            }
        }
        tableView.reloadData()
        self.scrollHorizontal.frame = CGRect(x:168 , y: y, width:80 , height: height)
    }
    
    @IBAction func btnBikeCar(_ sender: AnyObject) {
        self.topics = []
        for topic in listTopics {
            if topic.category == "Bike" {
                self.topics.append(topic)
            }
        }
        tableView.reloadData()
        self.scrollHorizontal.frame = CGRect(x:283 , y: y, width: 67, height: height)
    }
    
    @IBAction func btnMobile(_ sender: AnyObject) {
        self.topics = []
        for topic in listTopics {
            if topic.category == "Mobile" {
                self.topics.append(topic)
            }
        }
        tableView.reloadData()
        self.scrollHorizontal.frame = CGRect(x: 400, y: y, width: 57, height: height)
    }
    
    @IBAction func btnPet(_ sender: AnyObject) {
        self.topics = []
        for topic in listTopics {
            if topic.category == "Pet" {
                self.topics.append(topic)
            }
        }
        tableView.reloadData()
        self.scrollHorizontal.frame = CGRect(x: 497, y: y, width: 30, height: height)
    }
    
    @IBAction func btnFashion(_ sender: AnyObject) {
        self.topics = []
        for topic in listTopics {
            if topic.category == "Fashion" {
                self.topics.append(topic)
            }
        }
        tableView.reloadData()
        self.scrollHorizontal.frame = CGRect(x: 567, y: y, width: 63, height: height)
    }
    
    @IBAction func btnSport(_ sender: AnyObject) {
        self.topics = []
        for topic in listTopics {
            if topic.category == "Sport" {
                self.topics.append(topic)
            }
        }
        tableView.reloadData()
        self.scrollHorizontal.frame = CGRect(x: 670 , y: y, width: 48 , height: height)
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func barButtonItemMenu(_ sender: AnyObject) {
        moveMenuLef()
    }
    
    @IBAction func btnAddTopic(_ sender: AnyObject) {
        if UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.Email) == nil{
            
            self.showAlert()
        }else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "PostAddController") as! PostAddController
            
            self.navigationController?.pushViewController(yourVC, animated: true)}
    }
    
    @IBAction func btnSearch(_ sender: AnyObject) {
        if self.navigationItem.titleView == nil{
            
            self.navigationItem.titleView = searchController.searchBar
            
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: - RootViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFirebase()
        
        config()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Change navigation bar
        loadTabBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollview.frame = view.bounds
        
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
            self.topics = self.listTopics
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func loadTabBar() {
        // Navigation Bar
        navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController!.navigationBar.barTintColor = hexStringToUIColor("#00cd00")
        
        self.navigationController!.navigationBar.tintColor = UIColor.white
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredTopic = topics.filter({( topicModel : TopicModel) -> Bool in
            
            return topicModel.title!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchController.searchBar.text!)
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        
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

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath) as! HomeTableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredTopic.count
        }
        return topics.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topic = topics[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HomeTableViewCell {
            cell.configureCell(topic)
            return cell
        }else {
            return HomeTableViewCell()
        }
    }
}



extension HomeTableViewCell: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //        filterContentForSearchText(searchController.searchBar.text!)
        
    }
}

// MARK: - Config, Move Menu, Hiden Menu, Create Menu
extension HomeController{
    
    func config(){
        //Title
        title = "eBuy"
        //Change color for title navigationBar
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //Set layout Constraint Lef
        self.layoutConstraintLeft.constant = -UIScreen.main.bounds.size.width*0.65
        
        createMenuView()
        
        // Table delegate and table datasouce
        self.tableView.dataSource = self
        
        self.tableView.delegate = self
        
        // Disable separator line on one UITableViewCell
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //Search
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.viewScrollview.backgroundColor = self.hexStringToUIColor("#00cd00")
        
    }
    
    func moveMenuLef(){
        // layoutConstraintLeft
        if layoutConstraintLeft.constant == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutConstraintLeft.constant = -UIScreen.main.bounds.size.width*0.65
                
                self.coverBackground.alpha = 0
                
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutConstraintLeft.constant = 0
                
                self.coverBackground.alpha = 0.4
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func hidenLefMenu() {
        moveMenuLef()
    }
    
    func createMenuView() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LeftMenuController") as? LeftMenuController {
            vc.delegate = self
            
            self.addChildViewController(vc)
            
            Common.addAndFillSubviewIntoParentview(vc.view, parentview: viewMenu)
            
            vc.didMove(toParentViewController: self)
        }
    }
    
    // Alert move Login
    func showAlert(){
        let alert = UIAlertController(title: nil, message: "Please log in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",style: .default, handler: { action in
            self.LoginNavigation()
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL",style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    func showAlert(message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func LoginNavigation(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignInController") as! SignInController
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.navigationController?.isNavigationBarHidden = false
    }
}

