//
//  Top50ViewController.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/16/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit

import UIKit
import AVFoundation
import Kingfisher

class Top50ViewController: UIViewController {
    
    var token : String? = nil
    
    var refresh_token: String? = nil
    
    let client = Client(configuration: URLSessionConfiguration.default)
    
    let artistsTableView = UITableView()
    
    var albumns = [Album]()
    
    
    var player: AVAudioPlayer!
    var isPlaying = false
    var paused = false
    var trackPlaying = false
    var curretPlayingIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let token = (UserDefaults.standard.string(forKey: "token"))
        
        //        print(token)
        let refreshToken = UserDefaults.standard.string(forKey: "refresh_token")
        
        let global50 = "37i9dQZEVXbMDoHDwVN2tF"
        
        print(token)
        
        client.call(request: .getUserTopTracks(token: token!, completions: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tracks):
                //                print(tracks)
                self.albumns = tracks.items
                
                DispatchQueue.main.async {
                    self.configureTableView()
                }
            }
        }))
   
        configureNavBar()
  
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "MY TOP TRACKS"
    }
    
    @objc func authButtontapped() {
    }
    
    private func configureTableView() {
        artistsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(artistsTableView)
        artistsTableView.register(TableCell.self, forCellReuseIdentifier: String(describing: type(of: TableCell.self)))
        artistsTableView.dataSource = self
        artistsTableView.delegate = self
        artistsTableView.frame = self.view.bounds
    }
    
}



extension Top50ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: TableCell.self))) as! TableCell
        
        let artist = albumns[indexPath.row]
        //        print(artist.id)
        //        print(artist.album.images.first?.url)
        
        
        //        if let safeimages = artist.album.images {
        
        for image in artist.album!.images {
            if image.height == 300 {
            //                print(image.url)
            cell.imageView?.kf.setImage(with: image.url, options: []) { result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        cell.textLabel?.text = self.albumns[indexPath.row].name

                        cell.imageView?.image = value.image

                    }
                    cell.imageView?.image = value.image
                case .failure(let error):
                                            print("error")
//                    print(error)
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
            let track = albumns[indexPath.row]
            if let previewURL = track.previewUrl {
                downloadFileFromURL(url: previewURL)
            }
            curretPlayingIndex = indexPath.row
            
        }
        
        if curretPlayingIndex != indexPath.row {
            let track = albumns[indexPath.row]
            if let previewURL = track.previewUrl {
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
