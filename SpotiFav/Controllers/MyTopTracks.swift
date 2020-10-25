//
//  Top50ViewController.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/16/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit


class MyTopTracks: UIViewController {
    
    private let client = APIClient(configuration: URLSessionConfiguration.default)
    private let tableViewUserTopTracks = UITableView()
    private var simplifiedTracks = [SimpleTrack]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchAndConfigure()
    }
    
    private func fetchAndConfigure() {
        let token = (UserDefaults.standard.string(forKey: "token"))
        
        if token == nil {
            emptyMessage(message: "Tap Login Spotify", duration: 1.20)
        } else {
            
            client.call(request: .getUserTopTracks(token: token!, completions: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let tracks):
                    
                    for track in tracks.items {
                        let newTrack = SimpleTrack(artistName: track.artists.first?.name,
                                                   id: track.id,
                                                   title: track.name,
                                                   previewURL: track.previewUrl,
                                                   images: track.album!.images)
                        self.simplifiedTracks.append(newTrack)
                    }
                    
                    DispatchQueue.main.async {
                        self.configureTableView()
                    }
                }
            }))
        }
        configureNavBar()
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "MY TOP TRACKS"
    }
    
    private func configureTableView() {
        self.view.addSubview(tableViewUserTopTracks)
        tableViewUserTopTracks.translatesAutoresizingMaskIntoConstraints = false
        tableViewUserTopTracks.register(TableCell.self, forCellReuseIdentifier: String(describing: type(of: TableCell.self)))
        tableViewUserTopTracks.dataSource = self
        tableViewUserTopTracks.delegate = self
        tableViewUserTopTracks.frame = self.view.bounds
        tableViewUserTopTracks.separatorStyle = .none
    }
    
}

// MARK: - UITableView
extension MyTopTracks: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simplifiedTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: TableCell.self))) as! TableCell
        
        let track = simplifiedTracks[indexPath.row]
        cell.setTrack(song: track, hideHeartButton: true)
        cell.simplifiedTrack = track
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


