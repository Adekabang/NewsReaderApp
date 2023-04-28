//
//  ApiService.swift
//  NewsReaderApp
//
//  Created by Raska Mohammad on 29/04/23.
//

import Foundation

class ApiService {
    static let shared: ApiService = ApiService()
    private init() { }
    
    private let API_KEY = "poqAplnIabq4G81jyrGocLrIAYgT8W61"
    private let BASE_URL = "https://api.nytimes.com/svc/mostpopular/v2"
    
    func loadNews(completion: @escaping (Result<[News], Error>) -> Void) {
        let urlString = "\(BASE_URL)/viewed/7.json?api-key=\(API_KEY)"
        
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        if let data = data {
                            do {
                                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                                completion(.success(newsResponse.results))
                            } catch {
                                completion(.failure(error))
                            }
                        } else {
                            completion(.success([]))
                        }
                    }
                }
            }
            task.resume()
        } else {
            completion(.success([]))
        }
            
        
    }
}
