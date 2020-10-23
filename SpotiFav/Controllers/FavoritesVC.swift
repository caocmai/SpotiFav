//
//  FavoritesVC.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/30/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit


class FavoritesVC: UIViewController {
    
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    private var tableViewFavTracks = UITableView()
    private var simplifiedTracks = [SimpleTrack]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "My Favorites"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAndConfigFavTracks()
        
    }
    
    private func fetchAndConfigFavTracks() {
        let token = UserDefaults.standard.string(forKey: "token")
        var tracks: [String]?
        tracks = UserDefaults.standard.stringArray(forKey: "favTracks")
        
        if token == nil {
            emptyMessage(message: "Tap Auth Spotify", duration: 1.20)
        }else
            
            if tracks != nil && !tracks!.isEmpty {
                apiClient.call(request: .getFavTracks(ids: tracks!, token: token!, completion:
                    
                    { (playlist) in
                        switch playlist {
                        case .failure(let error):
                            print(error)
                        case .success(let playlist):
                            self.simplifiedTracks = [SimpleTrack]()
                            
                            for track in playlist.tracks {
                                let newTrack = SimpleTrack(artistName: track.album.artists.first?.name, id: track.id, title: track.name, previewURL: track.previewUrl, images: track.album.images!)
                                self.simplifiedTracks.append(newTrack)
                            }
                            
                            DispatchQueue.main.async {
                                self.configureTableView()
                                self.tableViewFavTracks.reloadData()
                            }
                        }
                }))
            } else {
                emptyMessage(message: "No Favorite Songs Yet", duration: 1.20)
                tableViewFavTracks.removeFromSuperview()
        }
    }
    
    private func configureTableView() {
        tableViewFavTracks.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableViewFavTracks)
        tableViewFavTracks.register(TableCell.self, forCellReuseIdentifier: String(describing: type(of: TableCell.self)))
        tableViewFavTracks.dataSource = self
        tableViewFavTracks.delegate = self
        tableViewFavTracks.frame = self.view.bounds
        tableViewFavTracks.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
}

// MARK: - UITableView
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        simplifiedTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: TableCell.self)), for: indexPath) as! TableCell
        
        cell.simplifiedTrack = simplifiedTracks[indexPath.row]
        cell.setTrack(song: simplifiedTracks[indexPath.row], hideHeartButton: false)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
