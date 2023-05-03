//
//  HomeViewController.swift
//  NewsReaderApp
//
//  Created by Raska Mohammad on 29/04/23.
//

import UIKit
import SDWebImage
import SafariServices

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var refreshControl: UIRefreshControl!
    weak var pageControl: UIPageControl?
    
    var topNewsList: [News] = []
    var latestNewsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.beginRefreshing()
        loadLatestNews()
        loadTopNews()
    }
    
    @objc func refresh(_ sender: Any) {
        loadLatestNews()
        loadTopNews()
    }
    
    // MARK: - Helpers
    func loadLatestNews () {
        ApiService.shared.loadLatestNews { result in
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let newsList):
                self.latestNewsList = newsList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadTopNews () {
        ApiService.shared.loadLatestNews { result in
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let newsList):
                self.topNewsList = newsList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topNewsList.count > 0 ? 1 : 0
        } else {
            return latestNewsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "top_news_list_cell", for: indexPath) as! TopNewsListViewCell
            
            cell.titleLabel.text = "News for you"
            cell.subtitleLabel.text = "Top \(topNewsList.count) News of the day"
            cell.pageControl.numberOfPages = topNewsList.count
            self.pageControl = cell.pageControl
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "custom_news_cell", for: indexPath) as! NewsViewCell
            let news = latestNewsList[indexPath.row]
            
            cell.titleLabel.text = news.title
            cell.dateLabel.text = "\(news.publishDate) · \(news.section)"
            
            cell.delegate = self
            
            
            if let url = news.media.first?.metadata.last?.url {
//                ApiService.shared.downloadImage(url: url) { result in
//                    switch result {
//                    case .success (let image):
//                        cell.thumbImageView.image = image
//                    case .failure:
//                        cell.thumbImageView.image = nil
//                    }
//                }
                cell.thumbImageView.sd_setImage(with: URL(string:url))

            } else {
                cell.thumbImageView.image = nil
            }
            //        cell.textLabel?.text = "\(indexPath.row+1).  " + news.title
            return cell
        }
        
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else {
            return
        }
        
        let news = latestNewsList[indexPath.row]
        
//        let alert = UIAlertController(title: news.title, message: news.url, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: .default))
//
//        present(alert, animated: true)
        
        if let url = URL(string: news.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topNewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_news_cell", for: indexPath) as! TopNewsViewCell
        
        let news = topNewsList[indexPath.item]
        if let urlString = news.media.first?.metadata.last?.url {
            cell.thumbImageView.sd_setImage(with: URL(string: urlString))
        } else {
            cell.thumbImageView.image = nil
        }
        
        cell.titleLabel.text = news.title
        cell.subtitleLabel.text = "\(news.publishDate) · \(news.section)"
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 256)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != self.tableView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl?.currentPage = page
            
        }
    }
}

// MARK: - NewsViewCellDelegate
extension HomeViewController: NewsViewCellDelegate {
    func NewsViewCellBookmarkButtonTapped(_ cell: NewsViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let news = latestNewsList[indexPath.row]
            print(news.title)
        }
    }

}
