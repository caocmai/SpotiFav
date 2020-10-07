//
//  ArtistTopTracksVC.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/24/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit


class ArtistTopTracksVC: UIViewController {
    
    let client = APIClient(configuration: URLSessionConfiguration.default)
    
    var artist: ArtistItem! {
        didSet {
            fetch()
        }
    }
    
    let table = UITableView()
    var tracks = [ArtistTrack]()
    
    var simplifiedTracks = [SimpleTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func configureTable() {
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.frame = self.view.bounds
        table.register(TableCell.self, forCellReuseIdentifier: String(describing: type(of: TableCell.self)))
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCell.SeparatorStyle.none

    }
    
    private func fetch() {
        let token = (UserDefaults.standard.string(forKey: "token"))

        client.call(request: .getArtistTopTracks(id: artist.id, token: token!, completions: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tracks):
//                self.tracks = tracks.tracks
                
                for track in tracks.tracks {
                    let newTrack = SimpleTrack(artistName: track.album.artists.first?.name, id: track.id, title: track.name, previewURL: track.previewUrl, images: track.album.images!)
                    self.simplifiedTracks.append(newTrack)
                }
                
                DispatchQueue.main.async {
                    self.title = self.artist.name
                    self.configureTable()
                }
            }
        }))
    }
    
    
}

extension ArtistTopTracksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simplifiedTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: TableCell.self))) as! TableCell

        let song = simplifiedTracks[indexPath.row]
        cell.simplifiedTrack = song
        cell.setTrack(song: song, hideHeartButton: false)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    
}


