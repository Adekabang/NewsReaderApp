//
//  HomeViewController.swift
//  NewsReaderApp
//
//  Created by Raska Mohammad on 29/04/23.
//

import UIKit
//import SDWebImage
import SafariServices

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var refreshControl: UIRefreshControl!
    
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
    }
    
    @objc func refresh(_ sender: Any) {
        loadLatestNews()
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

}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_news_cell", for: indexPath) as! NewsViewCell
        let news = latestNewsList[indexPath.row]
        
        cell.titleLabel.text = news.title
        cell.dateLabel.text = "\(news.publishDate) · \(news.section)"

        if let url = news.media.first?.metadata.last?.url {
            ApiService.shared.downloadImage(url: url) { result in
                switch result {
                case .success (let image):
                    cell.thumbImageView.image = image
                case .failure:
                    cell.thumbImageView.image = nil
                }
            }
        } else {
            cell.thumbImageView.image = nil
        }
//        cell.textLabel?.text = "\(indexPath.row+1).  " + news.title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
