//
//  FavoriteListTableViewController.swift
//  ShowTV
//
//  Created by 方芸萱 on 2021/6/11.
//

import UIKit

class FavoriteListTableViewController: UITableViewController {
    var tvIdDetailList = [TvIdDetail]()
    var favoriteList = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.tvListCellNibName, bundle: nil), forCellReuseIdentifier: K.tvListCellIdentifier)
        title = "Favorites"
        
        navigationItem.leftBarButtonItem = editButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteListUpdate), name: TvController.favoritesIdNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteListUpdate()
    }
    
    @objc func favoriteListUpdate(){
//        print(#function)
        favoriteList = TvController.shared.favoritesId
        tvIdDetailList = []
        for (index, id) in favoriteList.enumerated(){
//            print("index:\(index), id:\(id)")
            TvController.shared.fetchTvId(withId: id) { (tvDetail) in
                if let tvDetail = tvDetail{
                    self.tvIdDetailList.append(tvDetail)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }else{
                    TvController.shared.favoritesId.remove(at: index)
                }
            }
        }
        if tvIdDetailList.count == 0{
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvIdDetailList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tvListCellIdentifier, for: indexPath) as! TvListCell
        let tvDetail = tvIdDetailList[indexPath.row]
        cell.update(with: tvDetail)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            TvController.shared.favoritesId.remove(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.showFavoriteDetailSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.showFavoriteDetailSegue{
            let destinationVC = segue.destination as! FavoriteDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            destinationVC.tvIdDetail = tvIdDetailList[index]
        }
    }
}
