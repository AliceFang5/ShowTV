//
//  Model.swift
//  ShowTV
//
//  Created by 方芸萱 on 2021/6/9.
//

import Foundation

struct TvShowsLists:Decodable {
    var results:[TvItem]
}

struct TvItem:Decodable {
    let original_name:String
    let id:Int
    let overview:String
    let vote_average:Double
    let poster_path:String?
}

struct TvIdDetail:Decodable {
    let number_of_seasons:Int
    let number_of_episodes:Int
    let homepage:String?
}

struct TvVideos:Decodable {
    let results:[TvVideo]
}

struct TvVideo:Decodable {
    let key:String
    let site:String
}
