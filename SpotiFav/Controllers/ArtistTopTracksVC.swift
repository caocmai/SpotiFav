//
//  ArtistTopTracksVC.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/24/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit
import AVFoundation

class ArtistTopTracksVC: UIViewController {
    
    let client = Client(configuration: URLSessionConfiguration.default)
    
    // do the get here!
    var label: String! {
        didSet {
            fetch()
            
        }
    }
    
    var artist: ArtistItem! {
        didSet {
            fetch()
        }
    }
    
    let table = UITableView()
    
    var tracks = [ArtistTrack]()
    
    var test = ["a", "b", "c", "d"]
    
    var player: AVAudioPlayer!
    var isPlaying = false
    var paused = false
    var trackPlaying = false
    var curretPlayingIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let token = (UserDefaults.standard.string(forKey: "token"))
        
        //        print(token)
        //        let refreshToken = UserDefaults.standard.string(forKey: "refresh_token")
        
        //        let global50 = "37i9dQZEVXbMDoHDwVN2tF"
        
        //        print(token)
        
        
        
        
        // Do any additional setup after loading the view.
        //        self.view.addSubview(label)
        //        label.translatesAutoresizingMaskIntoConstraints = false
        //        NSLayoutConstraint.activate([
        //            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        //        ])
    }
    
    private func configureTable() {
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.frame = self.view.bounds
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    private func fetch() {
        client.call(request: .getArtistTopTracks(id: artist.id, token: (UserDefaults.standard.string(forKey: "token"))!, completions: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tracks):
                self.tracks = tracks.tracks
                //                for track in tracks.tracks {
                //                    print(track.name)
                //                }
                
                DispatchQueue.main.async {
                    self.title = self.artist.name
                    self.configureTable()
                }
            }
        }))
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ArtistTopTracksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let track = tracks[indexPath.row]
        //        cell.textLabel?.text = test[indexPath.row]
        for image in track.album.images! {
            //            if image.height == 160 {
            //            print(image.height)
            cell.imageView?.kf.setImage(with: image.url, options: []) { result in
                switch result {
                case .success(let value):
                    
                    DispatchQueue.main.async {
                        cell.textLabel?.text = track.name

                        cell.imageView?.image = value.image

                    }
                case .failure(let error):
                    print(error)
                }
                
            }
            
            //            }
        }
        
//        cell.imageView?.image = UIImage(named: "b")
        
        
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
            if let previewURL = track.previewUrl {
                downloadFileFromURL(url: URL(string: previewURL)!)
            }
            curretPlayingIndex = indexPath.row

        }
        
        if curretPlayingIndex != indexPath.row {
            let track = tracks[indexPath.row]
            if let previewURL = track.previewUrl {
                downloadFileFromURL(url: URL(string: previewURL)!)
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
