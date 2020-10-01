//
//  FavoritesVC.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/30/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        guard let refreshToken = UserDefaults.standard.string(forKey: "refresh_token") else {return nil}
        
//        let myarray = defaults.stringArray(forKey: "SavedStringArray") ?? [String]()

        
//        let token = (UserDefaults.standard.string(forKey: "token"))!
//
//        let tracks = UserDefaults.standard.stringArray(forKey: "favTracks")!
//
//        apiclient.call(request: .getFavTracks(ids: tracks, token: token, completion: { (playlis) in
//            switch playlis{
//            case .failure(let error):
//                print(error)
//            case .success(let playlist):
//                print(playlist)
//            }
//        }))
//
//    }
//
    
    
    
    let apiClient = APIClient(configuration: URLSessionConfiguration.default)
        
//        var tracks: [Item]!
        var trackTableView = UITableView()
        
//        var player: AVAudioPlayer!
        var isPlaying = false
        var paused = false
        var curretPlayingIndex = -1
        
        var simplifiedTracks = [SimpleTrack]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            
            let global50 = "37i9dQZEVXbMDoHDwVN2tF"
            
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.title = "My Favorites"
            let token = UserDefaults.standard.string(forKey: "token")
            print(token)
             
            let tracks = UserDefaults.standard.stringArray(forKey: "favTracks")!

            
            if token == nil {
                emptyMessage(message: "Tap Authenticate", duration: 1.20)
            } else {
                apiClient.call(request: .getFavTracks(ids: tracks, token: token!, completion:
                    
                    { (playlist) in
                    switch playlist {
                    case .failure(let error):
                        print(error)
                    case .success(let playlist):
                        //                self.tracks = playlist.tracks.items
                        //                print(playlist)
                        
                        for track in playlist.tracks {
                            let newTrack = SimpleTrack(id: track.id, title: track.name, previewURL: track.previewUrl, images: track.album.images!)
                            self.simplifiedTracks.append(newTrack)
                        }
                        
                        DispatchQueue.main.async {
//                            self.navigationItem.title = playlist.name
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
            cell.setTrack(song: simplifiedTracks[indexPath.row])

            cell.selectionStyle = .none
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
        
    
    
}
