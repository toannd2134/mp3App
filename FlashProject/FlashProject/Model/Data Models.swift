//
//  Data Models.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/7/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import Foundation


struct SearchResult: Codable{
    var data: [Track]
    var total: Int
    var next: String?
}


struct Artist: Codable{
    
    var id: Int
    var name: String
    var picture_xl: String
    var tracklist: String
    var numberOfFan: Int
    var numberOfAlbum: Int
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case picture_xl
        case tracklist
        case numberOfFan = "nb_fan"
        case numberOfAlbum = "nb_album"
    }
}

struct Album: Codable{
   
    var id: Int
    var title: String
    var cover_xl: String
    var tracklist: String
    var release_date: String
    var numberOfTracks: Int
    var artist: Artist
           
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case cover_xl
        case tracklist
        case release_date
        case numberOfTracks = "nb_tracks"
        case artist
    }
    
    struct Artist: Codable{
        var id: Int
        var name: String
        var picture: String
    }
}

struct Track: Codable{
    var id: Int
    var title: String
    var title_short: String
    var title_version: String?
    var preview: String
    var artist: Artist
    var album: Album?
    
    struct Artist: Codable, Hashable{
        static func ==(lhs: Artist, rhs: Artist) -> Bool{
            return lhs.id == rhs.id
        }
        var hashValue: Int{
            return self.id
        }
        var id: Int
        var name: String
        var picture_xl: String?
        var tracklist: String
    }
    
    struct Album: Codable, Hashable{
        static func ==(lhs: Album, rhs: Album) -> Bool{
            return lhs.id == rhs.id
        }
        var hashValue: Int{
            return self.id
        }
        var id: Int
        var title: String
        var cover_xl: String
        var tracklist: String
    }
}

