//
//  HomeViewController.swift
//  NewsReaderApp
//
//  Created by Raska Mohammad on 29/04/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var latesNewsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        loadLatestNews()
    }
    
    // MARK: - Helpers
    func loadLatestNews () {
        ApiService.shared.loadLatestNews { result in
            switch result {
            case .success(let newsList):
                self.latesNewsList = newsList
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
        return latesNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath)
        let news = latesNewsList[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row+1).  " + news.title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = latesNewsList[indexPath.row]
        let alert = UIAlertController(title: news.title, message: news.url, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        
        present(alert, animated: true)
    }
}
