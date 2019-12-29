//
//  Song.swift
//  guessTheSong
//
//  Created by 林伯翰 on 2019/12/15.
//  Copyright © 2019 Bruce Lin. All rights reserved.
//

import Foundation

struct Song: Codable {
    var artistName: String
    var trackName: String
    var previewUrl: URL
    var artworkUrl100: URL
}

struct SongResults: Codable {
    var resultCount: Int
    var results: [Song]
}
