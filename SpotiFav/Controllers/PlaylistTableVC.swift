//
//  PlaylistTableVC.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/27/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class PlaylistTableVC: UIViewController {
    
    let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    
    var tracks: [Item]!
    var trackTableView = UITableView()
    
    var player: AVAudioPlayer!
    var isPlaying = false
    var paused = false
    var curretPlayingIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let global50 = "37i9dQZEVXbMDoHDwVN2tF"

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Playlist"
        let token = UserDefaults.standard.string(forKey: "token")
        print(token)
        
        if token == nil {
            emptyMessage(message: "Tap Authenticate", duration: 1.20)
        } else {
        apiClient.call(request: .getPlaylist(token: token!, playlistId: global50, completions: { (playlist) in
            switch playlist {
            case .failure(let error):
                print(error)
            case .success(let playlist):
//                self.tracks = playlist.tracks.items
//                print(playlist)
                
                DispatchQueue.main.async {
                    self.navigationItem.title = playlist.name
                    self.tracks = playlist.tracks.items
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
        trackTableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: type(of: PlaylistTableVC.self)))
        trackTableView.frame = self.view.bounds
    }

}


extension PlaylistTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: PlaylistTableVC.self)))!
        let track = tracks[indexPath.row]
        
        
//        print(track.track.album?.images)
        
        for image in track.track.album!.images {
            if image.height == 300 {
                cell.imageView?.kf.setImage(with: image.url) { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let value):
                        
                        DispatchQueue.main.async {
                            cell.imageView?.image = value.image
                            cell.textLabel?.text = track.track.name

                        }
                    }

                }
            }
        }
        

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isPlaying == true && !paused{
            player.pause()
            paused = true
            print("paused")
        }
        else if isPlaying && paused {
            print("un pased")
            player.play()
            paused = false
        } else {
            let track = tracks[indexPath.row]
            if let previewURL = track.track.previewUrl {
                downloadFileFromURL(url: previewURL)
            }
            curretPlayingIndex = indexPath.row
            
        }
        
        if curretPlayingIndex != indexPath.row {
            let track = tracks[indexPath.row]
            if let previewURL = track.track.previewUrl {
                downloadFileFromURL(url: previewURL)
            }
            curretPlayingIndex = indexPath.row
        }
        
    }
    
    
    func downloadFileFromURL(url: URL){
        
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (URL, response, error) in
            
            self?.play(url: URL!)
        })
        
        downloadTask.resume()
        
    }
    
    func play(url: URL) {
        print("playing \(url)")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            //                        player.prepareToPlay()
            //            player.volume = 1.0
            player.play()
            isPlaying = true
            //            let test = player.currentTime
            //            Thread.sleep(forTimeInterval: 20)
            //            player.pause()
            //            Thread.sleep(forTimeInterval: 2)
            //            player.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }

}
