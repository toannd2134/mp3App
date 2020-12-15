//
//  CommunicationWithAPI.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/16/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import Foundation

class CommunicateWithAPI{
    
    struct ResultComponents{
        var tracks: [Track] = []
        var albums = Set<Track.Album>()
        var artists = Set<Track.Artist>()
    }
    static let shared = CommunicateWithAPI()
    
    var task: URLSessionDataTask?
    var resultComponents: ResultComponents?
    var track: Track?
    var album: Album?
    var artist: Artist?
    var trackList: [Track]?
    
    func search(with searchTerm: String,completionHander: @escaping () -> Void){
        task?.cancel()
        let search = searchTerm.replacingOccurrences(of: " ", with: "%20")
        var request = URLRequest(url: URL(string: "https://deezerdevs-deezer.p.rapidapi.com/search?q=\(search)")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.addValue("deezerdevs-deezer.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.addValue("db4897a763mshcb363b7d5353517p1337c0jsn3d319e20692b", forHTTPHeaderField: "x-rapidapi-key")
        task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self](data, response, error) in
            if let error = error{
                print(error)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{return}
            do{
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                self?.resultComponents = ResultComponents()
                self?.resultComponents?.tracks = searchResult.data
                for track in searchResult.data{
                    self?.resultComponents?.albums.insert(track.album!)
                    self?.resultComponents?.artists.insert(track.artist)
                }
                DispatchQueue.main.async {
                    completionHander()
                }
            }catch{
                print(error)
            }
        })
        task?.resume()
    }
    
    func getTrackById(id: Int, completionHander: @escaping () -> Void){
        task?.cancel()
        var request = URLRequest(url: URL(string: "https://deezerdevs-deezer.p.rapidapi.com/track/\(id)")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
               request.httpMethod = "GET"
               request.addValue("deezerdevs-deezer.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
               request.addValue("db4897a763mshcb363b7d5353517p1337c0jsn3d319e20692b", forHTTPHeaderField: "x-rapidapi-key")
               task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self](data, response, error) in
                   if let error = error{
                       print(error)
                       return
                   }
                   guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{return}
                   do{
                        self?.track = try JSONDecoder().decode(Track.self, from: data)
                        DispatchQueue.main.async {
                            completionHander()
                        }
                   }catch{
                       print(error)
                   }
               })
        task?.resume()
    }
    
    func getAlbumById(id: Int, completionHander: @escaping () -> Void){
        task?.cancel()
        var request = URLRequest(url: URL(string: "https://deezerdevs-deezer.p.rapidapi.com/album/\(id)")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.addValue("deezerdevs-deezer.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.addValue("db4897a763mshcb363b7d5353517p1337c0jsn3d319e20692b", forHTTPHeaderField: "x-rapidapi-key")
        task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self](data, response, error) in
            if let error = error{
                print(error)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{return}
            do{
                self?.album = try JSONDecoder().decode(Album.self, from: data)
                DispatchQueue.main.async {
                    completionHander()
                }
            }catch{
                print(error)
            }
        })
        task?.resume()
    }
    
    func getArtistById(id: Int, completionHander: @escaping () -> Void){
        task?.cancel()
        var request = URLRequest(url: URL(string: "https://deezerdevs-deezer.p.rapidapi.com/artist/\(id)")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.addValue("deezerdevs-deezer.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.addValue("db4897a763mshcb363b7d5353517p1337c0jsn3d319e20692b", forHTTPHeaderField: "x-rapidapi-key")
        task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self](data, response, error) in
            if let error = error{
                print(error)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{return}
            do{
                self?.artist = try JSONDecoder().decode(Artist.self, from: data)
                DispatchQueue.main.async {
                    completionHander()
                }
            }catch{
                print(error)
            }
        })
        task?.resume()
    }
    
    func getTrackListByLink(link: String, completionHander: @escaping () -> Void){
        task?.cancel()
               var request = URLRequest(url: URL(string: link)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                      request.httpMethod = "GET"
                      request.addValue("deezerdevs-deezer.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
                      request.addValue("db4897a763mshcb363b7d5353517p1337c0jsn3d319e20692b", forHTTPHeaderField: "x-rapidapi-key")
                      task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self](data, response, error) in
                          if let error = error{
                              print(error)
                              return
                          }
                          guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{return}
                          do{
                            let result = try JSONDecoder().decode(SearchResult.self, from: data)
                            self?.trackList = result.data
                               DispatchQueue.main.async {
                                   completionHander()
                               }
                          }catch{
                              print(error)
                          }
                      })
               task?.resume()
    }
    
    func reset(){
        self.task = nil
        self.resultComponents = nil
        self.album = nil
        self.artist = nil
    }
           
}
