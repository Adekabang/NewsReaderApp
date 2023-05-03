//
//  TopNewsListViewCell.swift
//  NewsReaderApp
//
//  Created by Raska Mohammad on 02/05/23.
//

import UIKit

protocol TopNewsListViewCellDelegate : AnyObject{
    func topNewsListViewCellPageControlValueChanged(_ cell: TopNewsListViewCell)
}

class TopNewsListViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate: TopNewsListViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pageControlValueChanged(_ sender: Any) {
        delegate?.topNewsListViewCellPageControlValueChanged(self)
    }
    
}
