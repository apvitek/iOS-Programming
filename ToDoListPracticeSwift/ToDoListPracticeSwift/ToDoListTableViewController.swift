//
//  ToDoListTableViewController.swift
//  ToDoListPracticeSwift
//
//  Created by Andrea Borghi on 10/3/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit

class ToDoListTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    var listItemsArray = [ToDoListItem]()
    var listItemsResults = [ToDoListItem]()
    let reuseIdentifier = "To Do Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchDisplayController?.delegate = self
        
        tableView.registerNib(UINib(nibName:"ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        searchDisplayController!.searchResultsTableView.registerNib(UINib(nibName:"ToDoSearchResultCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        populateTable()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchDisplayController!.searchResultsTableView {
            return listItemsResults.count
        } else {
            return listItemsArray.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        var item: ToDoListItem
        
        if tableView == searchDisplayController!.searchResultsTableView {
            item = listItemsResults[indexPath.row]
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? ToDoSearchResultCell
            
            if cell == nil {
                cell = ToDoSearchResultCell(style:.Default, reuseIdentifier: reuseIdentifier)
            }
            
            (cell as ToDoSearchResultCell).titleLabel.text = item.itemTitle + " - " + item.itemDescription
            if let picture = item.itemImage {
                (cell as ToDoSearchResultCell).itemPictureView?.image = picture
            }
            
        } else {
            item = listItemsArray[indexPath.row]
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? ToDoTableViewCell
            
            if cell == nil {
                cell = ToDoTableViewCell(style:.Default, reuseIdentifier: reuseIdentifier)
            }
            
            (cell as ToDoTableViewCell).titleLabel.text = item.itemTitle
            (cell as ToDoTableViewCell).subtitleLabel.text = item.itemDescription
            if let picture = item.itemImage {
                (cell as ToDoTableViewCell).itemPictureView?.image = picture
            }
            (cell as ToDoTableViewCell).quantityLabel.text = String(item.quantity)
        }
        
        if item.checked == true {
            cell?.accessoryType = .Checkmark
        } else {
            cell?.accessoryType = .None
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == searchDisplayController!.searchResultsTableView {
            return 60
        }
        
        return tableView.rowHeight
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        listItemsResults = listItemsArray.filter({( item : ToDoListItem) -> Bool in
            var categoryMatch = (scope == "All")
            var stringMatch = item.itemTitle.lowercaseString.rangeOfString(searchText.lowercaseString)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        filterContentForSearchText(searchDisplayController!.searchBar.text)
        return true
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView == searchDisplayController!.searchResultsTableView {
            return false
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        listItemsArray.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath), withRowAnimation:.Right)
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.tableView {
            var cell = tableView.cellForRowAtIndexPath(indexPath)
            
            if listItemsArray[indexPath.row].checked == true {
                cell?.accessoryType = .None
                listItemsArray[indexPath.row].checked = false
            } else {
                cell?.accessoryType = .Checkmark
                listItemsArray[indexPath.row].checked = true
            }
            
            performSegueWithIdentifier("showDetail", sender: listItemsArray[indexPath.row])
        } else {
            performSegueWithIdentifier("showDetail", sender: listItemsResults[indexPath.row])
        }
        
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var detailsView = segue.destinationViewController as ToDoListDetailViewController
            let item = sender as ToDoListItem
            detailsView.itemTitle = item.itemTitle
            detailsView.itemSubtitle = item.itemDescription
            detailsView.itemPicture = item.itemImage
            detailsView.itemInfo = item.itemInfo
            detailsView.itemQuantity = item.quantity
        }
    }
    
    func populateTable() {
        var titleList = ["Milk", "Cereals", "Orange Juice", "Coffee", "Chocolate", "Green Beans", "Tomatoes", "Rice"]
        var subtitleList = ["Buy milk", "Buy cereals", "Buy orange juice", "Buy coffee", "Buy chocolate", "Buy green beans", "Buy tomatoes", "Buy rice"]
        var imagesList = ["milk", "cereals", "orangeJuice", "coffee", "chocolate", "greenBeans", "tomatoes", "rice"]
        var infoList = [
            "Milk is a white liquid produced by the mammary glands of mammals. It is the primary source of nutrition for young mammals before they are able to digest other types of food. Early-lactation milk contains colostrum, which carries the mother's antibodies to the baby and can reduce the risk of many diseases in the baby. It also contains many other nutrients.",
            "A cereal is a grass, a member of the monocot family Poaceae, cultivated for the edible components of its grain (botanically, a type of fruit called a caryopsis), composed of the endosperm, germ, and bran. Cereal grains are grown in greater quantities and provide more food energy worldwide than any other type of crop; they are therefore staple crops.",
            "Orange juice is juice from oranges. It is made by squeezing the fresh orange, drying and later re-hydrating the juice, or concentration of the juice and later adding water to the concentrate. It is known for its health benefits, particularly its high concentration of vitamin C. It comes in several different varieties, including blood orange. In American English, the slang term O.J. may also be used to refer to orange juice.",
            "Coffee is a brewed beverage prepared from the roasted or baked seeds of several species of an evergreen shrub of the genus Coffea. The two most common sources of coffee beans are the highly regarded Coffea arabica, and the \"robusta\" form of the hardier Coffea canephora. The latter is resistant to the coffee leaf rust (Hemileia vastatrix), but has a more bitter taste. Coffee plants are cultivated in more than 70 countries, primarily in equatorial Latin America, Southeast Asia, and Africa. Once ripe, coffee \"berries\" are picked, processed and dried to yield the seeds inside. The seeds are then roasted to varying degrees, depending on the desired flavor, before being ground and brewed to create coffee.",
            "Chocolate is a typically sweet, usually brown, food preparation of Theobroma cacao seeds, roasted and ground, often flavored, as with vanilla. It is made in the form of a liquid, paste or in a block or used as a flavoring ingredient in other sweet foods. Cacao has been cultivated by many cultures for at least three millennia in Mexico and Central America. The earliest evidence of use traces to the Mokaya, with evidence of chocolate beverages dating back to 1900 BC.",
            "Green beans, also known as string bean, snap bean in the northeastern and western United States, or ejotes in Mexico, are the unripe fruit of various cultivars of the common bean (Phaseolus vulgaris).[1][2] Green bean cultivars have been selected especially for the fleshiness, flavor, or sweetness of their pods. Haricots verts, French for \"green beans\", also known as French beans, French green beans, French filet beans, Fine beans (British English), is a variety of green bean that is longer, thinner, crisp, and tender.[citation needed] It is different from the haricot bean, which is a dry bean.",
            "The tomato is the edible, often red fruit/berry of the nightshade Solanum lycopersicum, commonly known as a tomato plant. The species originated in the South American Andes and its use as a food originated in Mexico, and spread throughout the world following the Spanish colonization of the Americas. Its many varieties are now widely grown, sometimes in greenhouses in cooler climates.",
            "Rice is the seed of the monocot plants Oryza sativa (Asian rice) or Oryza glaberrima (African rice). As a cereal grain, it is the most widely consumed staple food for a large part of the world's human population, especially in Asia. It is the agricultural commodity with the third-highest worldwide production, after sugarcane and maize, according to data of FAOSTAT 2012."
        ]
        
        for i in 0..<titleList.count {
            var randomNumber = random() % 10 + 1
            listItemsArray.append(ToDoListItem(title: titleList[i], description: subtitleList[i], image: UIImage(named: imagesList[i]), info: infoList[i], quantity: randomNumber))
        }
    }
}