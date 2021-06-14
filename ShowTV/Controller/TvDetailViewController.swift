//
//  TvDetailViewController.swift
//  ShowTV
//
//  Created by 方芸萱 on 2021/6/11.
//

import UIKit
import SafariServices

class TvDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var homepageBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var tvItem:TvItem!
    var tvVideos = [TvVideo]()
    var btnToggleState = false
    var homepage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tvItem.original_name
        nameLabel.text = tvItem.original_name
        ratedLabel.text = String(format: "⭐️%.1f", tvItem.vote_average)
        overviewLabel.text = tvItem.overview
        homepageBtn.isEnabled = false
        videoBtn.isEnabled = false
        
        TvController.shared.fetchImage(withPath: tvItem.poster_path ?? "") { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.itemImageView.image = image
            }
        }
        
        TvController.shared.fetchTvId(withId: tvItem.id) { (tvIdDetail) in
            if let tvIdDetail = tvIdDetail{
                if let homepage = tvIdDetail.homepage{
                    self.homepage = homepage
                    DispatchQueue.main.async {
                        self.homepageBtn.isEnabled = true
                    }
                }
                DispatchQueue.main.async {
                    self.seasonEpisodeLabel.text = "Seanson \(tvIdDetail.number_of_seasons), Episodes \(tvIdDetail.number_of_episodes)"
                }
            }
        }
        
        TvController.shared.fetchTvVideos(withId: tvItem.id, withSeason: 1) { (tvVideos) in
            if let tvVideos = tvVideos{
                print(tvVideos)
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
    
    @IBAction func favoriteBtnPressed(_ sender: UIButton) {
        if btnToggleState{
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        btnToggleState = !btnToggleState
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
