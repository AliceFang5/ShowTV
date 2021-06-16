//
//  FavoriteListTableViewController.swift
//  ShowTV
//
//  Created by 方芸萱 on 2021/6/11.
//

import UIKit

class FavoriteListTableViewController: UITableViewController {
    var tvList = [TvItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.tvListCellNibName, bundle: nil), forCellReuseIdentifier: K.tvListCellIdentifier)
        title = "Favorites"
        
        NotificationCenter.default.addObserver(tableView, selector: #selector(UITableView.reloadData), name: TvController.favoritesIdNotification, object: nil)

        TvController.shared.fetchTvShows(withApi: K.popularAPI) { (items) in
            if let items = items{
                DispatchQueue.main.async {
                    self.tvList = items
                    self.tableView.reloadData()
                }
            }
        }
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
}
