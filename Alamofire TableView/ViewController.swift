//
//  ViewController.swift
//  Alamofire TableView
//
//  Created by Eduardo on 12/11/2018.
//  Copyright © 2018 Eduardo Jordan Muñoz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
//Primero los Datos
    var arrayData = [[String: AnyObject]]()
    var filterArray = [[String:AnyObject]]()
    
    var isSearching = false
    
// IBOUTLET del storyBoard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
//
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search Ingredient"
        
        filterArray = arrayData
        
        Alamofire.request("http://www.recipepuppy.com/api/").responseJSON { (responseData) -> Void in
            if ((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.arrayData = resData as! [[String: AnyObject]]
                }
                if self.arrayData.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    
 //   Mark: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearching){
        return filterArray.count
        }else{
        return arrayData.count
    }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "theCell")!
        
        if(isSearching){
        var dict = filterArray[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = dict["title"] as? String
        cell.detailTextLabel?.text = dict["ingredients"] as? String
        }else{
        var dict = arrayData[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = dict["title"] as? String
        cell.detailTextLabel?.text = dict["ingredients"] as? String
        }
   //  Get Image from Api
  //        let url = URL(string: (dict["thumbnail"] as? String)!)
  //        if  url == nil {
  //            cell.imageView?.image = UIImage(named: "placeholder")
  //        }else{
  //        cell.imageView?.setImage(with: url!)
  //                }
        
        return cell
    }
    
// Mark : SearchBar
    
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         guard !searchText.isEmpty else{
            filterArray = arrayData
            tableView.reloadData()
            return
            
        }
        filterArray = arrayData.filter ({recipe -> Bool in
            let ingredients = recipe ["ingredients"] as! String
            return ingredients.contains(searchText.lowercased())
          })
        
        if(filterArray.count == 0){
            isSearching = false
        }else{
            isSearching = true
        }
        
        tableView.reloadData()
    }
}

private extension UIImageView{
    func setImage(with url:URL){
        Alamofire.request(url).responseData { (response) in
            let image = UIImage(data: response.data!)
            DispatchQueue.main.async {
                self.image = image
            }

        }
    }
}




