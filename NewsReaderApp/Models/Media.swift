//
//  Media.swift
//  NewsReaderApp
//
//  Created by Raska Mohammad on 28/04/23.
//

import Foundation

struct Media: Decodable {
    let type: String
    let caption: String
    let metadata: [MediaMetadata]
    
    enum CodingKeys: String, CodingKey {
        case type
        case caption
        case metadata = "media-metadata"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.caption = try container.decodeIfPresent(String.self, forKey: .caption) ?? ""
        self.metadata = try container.decodeIfPresent([MediaMetadata].self, forKey: .metadata) ?? []
    }
    
    init(type: String, caption: String, metadata: [MediaMetadata]) {
        self.type = type
        self.caption = caption
        self.metadata = metadata
    }
}
