//
//  TvController.swift
//  ShowTV
//
//  Created by 方芸萱 on 2021/6/9.
//

import UIKit

class TvController{
    static let shared = TvController()
    let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    let imageURL = URL(string: "https://image.tmdb.org/t/p/w342")!
    var queries = [
        "api_key":"",
        "language":"en-US",
        "page":"1",
        "query":""
    ]
    
    func fetchTvShows(withApi apiString:String, withSearch searchString:String, completion: @escaping ([TvItem]?) -> Void){
        let initialURL = baseURL.appendingPathComponent(apiString)
        var component = URLComponents(url: initialURL, resolvingAgainstBaseURL: true)!
        queries.updateValue(searchString, forKey: "query")
        component.queryItems = queries.map{
            URLQueryItem(name: $0.key, value: $0.value)
        }
        let tvShowsURL = component.url!
        print(tvShowsURL)
        let task = URLSession.shared.dataTask(with: tvShowsURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let tvShowsLists = try? jsonDecoder.decode(TvShowsLists.self, from: data){
                print(tvShowsLists)
                completion(tvShowsLists.results)
            }else{
                completion(nil)
            }
        }
        task.resume()
    }

    func fetchTvId(withId id:Int, completion: @escaping (TvIdDetail?) -> Void){
        let initialURL = baseURL.appendingPathComponent("tv/\(id)")
        var component = URLComponents(url: initialURL, resolvingAgainstBaseURL: true)!
        component.queryItems = queries.map{
            URLQueryItem(name: $0.key, value: $0.value)
        }
        let tvIdURL = component.url!
        print(tvIdURL)
        let task = URLSession.shared.dataTask(with: tvIdURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data{
                do{
                    let tvIdDetail = try jsonDecoder.decode(TvIdDetail.self, from: data)
                    print(tvIdDetail)
                    completion(tvIdDetail)
                }catch{
                    print(error)
                }
            }else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchTvVideos(withId id:Int, withSeason season:Int, completion: @escaping ([TvVideo]?) -> Void){
        let initialURL = baseURL.appendingPathComponent("tv/\(id)/season/\(season)/videos")
        var component = URLComponents(url: initialURL, resolvingAgainstBaseURL: true)!
        component.queryItems = queries.map{
            URLQueryItem(name: $0.key, value: $0.value)
        }
        let tvVideosURL = component.url!
        print(tvVideosURL)
        let task = URLSession.shared.dataTask(with: tvVideosURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data{
                do{
                    let tvVideos = try jsonDecoder.decode(TvVideos.self, from: data)
                    print(tvVideos)
                    completion(tvVideos.results)
                }catch{
                    print(error)
                }
            }else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchImage(withPath path:String, completion: @escaping (UIImage?) -> Void){
        let pathURL = imageURL.appendingPathComponent(path)
        print(pathURL)
        let task = URLSession.shared.dataTask(with: pathURL) { (data, response, error) in
            if let data = data, let image = UIImage(data: data){
                completion(image)
            }else{
                completion(nil)
            }
        }
        task.resume()
    }
}
