//
//  FavoriteDetailViewController.swift
//  ShowTV
//
//  Created by 方芸萱 on 2021/6/16.
//

import UIKit
import SafariServices

class FavoriteDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var homepageBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var tvIdDetail:TvIdDetail!
    var tvVideos = [TvVideo]()
    var homepage = ""
    var favoriteList = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tvIdDetail.original_name
        nameLabel.text = tvIdDetail.original_name
        ratedLabel.text = String(format: "⭐️%.1f", tvIdDetail.vote_average)
        overviewLabel.text = tvIdDetail.overview
        seasonEpisodeLabel.text = "Seanson \(tvIdDetail.number_of_seasons), Episodes \(tvIdDetail.number_of_episodes)"
        if tvIdDetail.homepage != nil{
            homepageBtn.isEnabled = true
        }else{
            homepageBtn.isEnabled = false
        }
        videoBtn.isEnabled = false
        
        //initial favoriteBtn setting
        favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteBtn.isEnabled = false
        
        TvController.shared.fetchImage(withPath: tvIdDetail.poster_path ?? "") { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.itemImageView.image = image
            }
        }
        
        TvController.shared.fetchTvId(withId: tvIdDetail.id) { (tvIdDetail) in
            if let tvIdDetail = tvIdDetail{
                if let homepage = tvIdDetail.homepage{
                    self.homepage = homepage
                    DispatchQueue.main.async {
                        self.homepageBtn.isEnabled = true
                    }
                }
            }
        }
        
        TvController.shared.fetchTvVideos(withId: tvIdDetail.id, withSeason: 1) { (tvVideos) in
            if let tvVideos = tvVideos{
//                print(tvVideos)
                if tvVideos.count != 0 {
                    self.tvVideos = tvVideos
                    DispatchQueue.main.async {
                        self.videoBtn.isEnabled = true
                    }
                }
            }
        }
    }
    
    @IBAction func homepageBtnPressed(_ sender: UIButton) {
        if let url = URL(string: homepage){
            let safari = SFSafariViewController(url: url)
            present(safari, animated: true, completion: nil)
        }
    }
    
    //http://youtube.com/watch?v=
    @IBAction func videoBtnPressed(_ sender: UIButton) {
        for video in tvVideos{
            if video.site == "YouTube"{
                let urlString = "http://youtube.com/watch?v=\(video.key)"
                if let url = URL(string: urlString){
                    let safari = SFSafariViewController(url: url)
                    present(safari, animated: true, completion: nil)
                }
            }
        }
    }

}
