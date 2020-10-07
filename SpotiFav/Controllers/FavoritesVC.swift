//
//  FavoritesVC.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/30/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
    
    let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    var trackTableView = UITableView()
    var simplifiedTracks = [SimpleTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "My Favorites"
        let token = UserDefaults.standard.string(forKey: "token")
        print("token", token)
        
        if token == nil {
            emptyMessage(message: "Tap Auth Spotify", duration: 1.20)
        } else {
            print("tack empty")
            emptyMessage(message: "No Favorite Songs Yet", duration: 1.20)
        }
        
        guard let tracks = UserDefaults.standard.stringArray(forKey: "favTracks") else {return}
        print("tracks", tracks)
        if !tracks.isEmpty {
            apiClient.call(request: .getFavTracks(ids: tracks, token: token!, completion:
                
                { (playlist) in
                    switch playlist {
                    case .failure(let error):
                        print(error)
                    case .success(let playlist):
                        //                self.tracks = playlist.tracks.items
                        //                print(playlist)
                        
                        for track in playlist.tracks {
                            let newTrack = SimpleTrack(artistName: track.album.artists.first?.name, id: track.id, title: track.name, previewURL: track.previewUrl, images: track.album.images!)
                            self.simplifiedTracks.append(newTrack)
                        }
                        
                        DispatchQueue.main.async {
                            //                            self.navigationItem.title = playlist.name
                            //                        self.tracks = playlist.tracks.items
                            self.configureTableView()
                        }
                    }
            }))
        } else {
            emptyMessage(message: "No Favorite Songs Yet", duration: 1.20)
        }
        
        
    }
    
    private func configureTableView() {
        self.view.addSubview(trackTableView)
        trackTableView.translatesAutoresizingMaskIntoConstraints = false
        trackTableView.dataSource = self
        trackTableView.delegate = self
        trackTableView.register(TableCell.self, forCellReuseIdentifier: String(describing: type(of: TableCell.self)))
        trackTableView.frame = self.view.bounds
        trackTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
}


extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        simplifiedTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: TableCell.self)), for: indexPath) as! TableCell
        
        //        cell.track = tracks[indexPath.row]
        cell.simplifiedTrack = simplifiedTracks[indexPath.row]
        cell.setTrack(song: simplifiedTracks[indexPath.row], hideHeartButton: false)
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}
