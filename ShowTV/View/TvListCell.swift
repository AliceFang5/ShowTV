//
//  TvListCell.swift
//  ShowTV
//
//  Created by 方芸萱 on 2021/6/9.
//

import UIKit

class TvListCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with tvItem:TvItem){
        nameLabel.text = tvItem.original_name
        ratedLabel.text = String(format: "⭐️%.1f", tvItem.vote_average)
        overviewLabel.text = tvItem.overview
        TvController.shared.fetchImage(withPath: tvItem.poster_path ?? "") { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.itemImageView?.image = image
                self.setNeedsLayout()
            }
        }
    }
    
    func update(with tvDetail:TvIdDetail){
        nameLabel.text = tvDetail.original_name
        ratedLabel.text = String(format: "⭐️%.1f", tvDetail.vote_average)
        overviewLabel.text = tvDetail.overview
        TvController.shared.fetchImage(withPath: tvDetail.poster_path ?? "") { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.itemImageView?.image = image
                self.setNeedsLayout()
            }
        }
    }
}
