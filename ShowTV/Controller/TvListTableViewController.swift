//
//  TvListTableViewController.swift
//  ShowTV
//
//  Created by 方芸萱 on 2021/6/9.
//

import UIKit

class TvListTableViewController: UITableViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
        let searchString = searchController.searchBar.text!
        print(searchString)
        TvController.shared.fetchTvShows(withApi: K.searchAPI, withSearch: searchString) { (items) in
            if let items = items{
                DispatchQueue.main.async {
                    self.tvList = items
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    var tvList = [TvItem]()
    var category : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.tvListCellNibName, bundle: nil), forCellReuseIdentifier: K.tvListCellIdentifier)
        title = category
        
        guard category != K.searchString else {
            insertSearchBar()
            return
        }
        
        var apiString = ""
        switch category {
        case K.topRatedString:
            apiString = K.topRatedAPI
        case K.popularString:
            apiString = K.popularAPI
        case K.onTheAirString:
            apiString = K.onTheAirAPI
        default:
            break
        }

        TvController.shared.fetchTvShows(withApi: apiString, withSearch: "") { (items) in
            if let items = items{
                DispatchQueue.main.async {
                    self.tvList = items
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func insertSearchBar(){
        print(#function)
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
//        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.hidesNavigationBarDuringPresentation = false
//        searchBar.searchBar.placeholder = "search..."
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchBar
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tvListCellIdentifier, for: indexPath) as! TvListCell
        let tvItem = tvList[indexPath.row]
        cell.update(with: tvItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.showTvDetailSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.showTvDetailSegue{
            let destinationVC = segue.destination as! TvDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            destinationVC.tvItem = tvList[index]
        }
    }
}
