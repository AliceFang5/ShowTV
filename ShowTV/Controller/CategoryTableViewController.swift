//
//  CategoryTableViewController.swift
//  ShowTV
//
//  Created by 方芸萱 on 2021/6/10.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    let categories : [String] = [
        K.topRatedString,
        K.popularString,
        K.onTheAirString,
        K.searchString
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TV Shows"

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.showTvListSegue {
            let destinationVC = segue.destination as! TvListTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            destinationVC.category = categories[index]
        }
    }
}
