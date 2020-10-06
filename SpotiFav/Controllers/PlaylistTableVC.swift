//
//  PlaylistTableVC.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/27/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit


class PlaylistTableVC: UIViewController {
    
    let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    
    var tracks: [Item]!
    var trackTableView = UITableView()
    
    var simplifiedTracks = [SimpleTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let global50 = "37i9dQZEVXbMDoHDwVN2tF"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Playlist"
        let token = UserDefaults.standard.string(forKey: "token")
        print(token)
        
        if token == nil {
            emptyMessage(message: "Tap Auth Spotify", duration: 1.20)
        } else {
            apiClient.call(request: .getPlaylist(token: token!, playlistId: global50, completions: { (playlist) in
                switch playlist {
                case .failure(let error):
                    print(error)
                case .success(let playlist):
                    //                self.tracks = playlist.tracks.items
                    //                print(playlist)
                    
                    for track in playlist.tracks.items {
                        let newTrack = SimpleTrack(artistName: track.track.artists.first?.name, id: track.track.id, title: track.track.name, previewURL: track.track.previewUrl, images: track.track.album!.images)
                        self.simplifiedTracks.append(newTrack)
                    }
                    
                    DispatchQueue.main.async {
                        self.navigationItem.title = playlist.name
//                        self.tracks = playlist.tracks.items
                        self.configureTableView()
                    }
                }
            }))
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


extension PlaylistTableVC: UITableViewDelegate, UITableViewDataSource {
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
