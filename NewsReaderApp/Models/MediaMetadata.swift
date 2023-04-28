//
//  MediaMetadata.swift
//  NewsReaderApp
//
//  Created by Raska Mohammad on 28/04/23.
//

import Foundation

struct MediaMetadata: Decodable {
    let url: String
    let format: String
    let height: Double
    let width: Double
    
    enum CodingKeys: String, CodingKey {
        case url
        case format
        case height
        case width
    }
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        format = try container.decodeIfPresent(String.self, forKey: .format) ?? ""
        height = try container.decodeIfPresent(Double.self, forKey: .height) ?? 0.0
        width = try container.decodeIfPresent(Double.self, forKey: .width) ?? 0.0
        
    }
}
