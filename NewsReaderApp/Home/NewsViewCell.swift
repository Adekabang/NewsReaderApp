//
//  NewsViewCell.swift
//  NewsReaderApp
//
//  Created by Raska Mohammad on 01/05/23.
//

import UIKit

protocol NewsViewCellDelegate: AnyObject {
    func NewsViewCellBookmarkButtonTapped(_ cell: NewsViewCell)
}

class NewsViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    weak var delegate: NewsViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        thumbImageView.layer.cornerRadius = 8
        thumbImageView.layer.masksToBounds = true
        thumbImageView.contentMode = .scaleAspectFill
    }

    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        delegate?.NewsViewCellBookmarkButtonTapped(self)
    }
}
