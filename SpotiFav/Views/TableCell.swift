//
//  TableCell.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/24/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit
import AVFoundation

class TableCell: UITableViewCell {
    
    let label = UILabel()
    let cellImage = UIImageView()
    
    var track: Item!
    
    var simplifiedTrack: SimpleTrack!
    
    lazy var heartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    let playbackImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let play = UIImage(systemName: "play.fill")
        let playGray = play?.withTintColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), renderingMode: .alwaysOriginal)
        image.image = playGray
        return image
    }()
    
    lazy var hiddenPlayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hiddenPlayButtonTapped), for: .touchUpInside)
        //        button.backgroundColor = .blue
        return button
    }()
    
    var currentPlayingId: String? = nil
    
    var favArrayIds = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        favArrayIds = UserDefaults.standard.stringArray(forKey: "favTracks") ?? [String]()
        //        print(favArrayIds)
        
        currentPlayingId = UserDefaults.standard.string(forKey: "current_playing_id")
        //        isPlaying = UserDefaults.standard.bool(forKey: "isPlaying")
        //        print(isPlaying)
        
    }
    
    @objc func heartTapped() {
        let heart = UIImage(systemName: "heart.fill")
        let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
        heartButton.setImage(redHeartColor, for: .normal)
        favArrayIds.append(simplifiedTrack.id)
        print(favArrayIds)
        UserDefaults.standard.set(favArrayIds, forKey: "favTracks")
        
    }
    
    @objc func hiddenPlayButtonTapped() {
        //        print(currentPlayingId)
        
        if Player.shared.player == nil {
            print("player not playing")
            if let previewURL = simplifiedTrack.previewUrl {
                Player.shared.downloadFileFromURL(url: previewURL)
            }
            currentPlayingId = simplifiedTrack.id
            UserDefaults.standard.set(currentPlayingId, forKey: "current_playing_id")
            let play = UIImage(systemName: "pause.fill")
            let playGray = play?.withTintColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), renderingMode: .alwaysOriginal)
            playbackImage.image = playGray
            
        }
        
        
        if currentPlayingId != simplifiedTrack.id {
            if let previewURL = simplifiedTrack.previewUrl {
                Player.shared.downloadFileFromURL(url: previewURL)
            }
            currentPlayingId = simplifiedTrack.id
            UserDefaults.standard.set(currentPlayingId, forKey: "current_playing_id")
            
            DispatchQueue.main.async {
                let play = UIImage(systemName: "pause.fill")
                let playGray = play?.withTintColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), renderingMode: .alwaysOriginal)
                self.playbackImage.image = playGray
            }
            
        }
        
        if let player = Player.shared.player {
            if player.isPlaying {
                print("yes")
                player.pause()
                
                let play = UIImage(systemName: "play.fill")
                let playGray = play?.withTintColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), renderingMode: .alwaysOriginal)
                playbackImage.image = playGray
                
            } else {
                player.play()
                let play = UIImage(systemName: "pause.fill")
                let playGray = play?.withTintColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), renderingMode: .alwaysOriginal)
                playbackImage.image = playGray
                
                
            }
            
        }

    }
    
    func setTrack(song: SimpleTrack) {
        //        print(favArrayIds)
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        //        playbackImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(heartButton)
        self.contentView.addSubview(label)
        self.contentView.addSubview(cellImage)
        self.contentView.addSubview(hiddenPlayButton)
        self.contentView.addSubview(playbackImage)
        
        cellImage.contentMode = .scaleAspectFit
        
        if song.previewUrl == nil {
            hiddenPlayButton.isHidden = true
            playbackImage.isHidden = true

        } else {

            hiddenPlayButton.isHidden = false
            playbackImage.isHidden = false
        }
        
        if !favArrayIds.isEmpty {
            if favArrayIds.contains(song.id) {
                let heart = UIImage(systemName: "heart.fill")
                let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
                heartButton.setImage(redHeartColor, for: .normal)
            }else {
                let heart = UIImage(systemName: "heart")
                let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
                heartButton.setImage(redHeartColor, for: .normal)
            }
            
        } else {
            let heart = UIImage(systemName: "heart")
            let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
            heartButton.setImage(redHeartColor, for: .normal)
        }
        
        
        if let player = Player.shared.player {
            if player.isPlaying {
                if currentPlayingId == song.id {
                    let play = UIImage(systemName: "pause.fill")
                    let playGray = play?.withTintColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), renderingMode: .alwaysOriginal)
                    playbackImage.image = playGray
                } else {
                    let play = UIImage(systemName: "play.fill")
                    let playGray = play?.withTintColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), renderingMode: .alwaysOriginal)
                    playbackImage.image = playGray
                }
                
            }
        }
        
        
        
        
        NSLayoutConstraint.activate([
            
            
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            //            cellImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            cellImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            cellImage.widthAnchor.constraint(equalTo: self.contentView.heightAnchor),
            
            label.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: self.playbackImage.leadingAnchor, constant: 3),
            
            
            playbackImage.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: 8),
           playbackImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -40),
           playbackImage.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -40),
           playbackImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            
            hiddenPlayButton.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            hiddenPlayButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            hiddenPlayButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            //            playButton.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),
            hiddenPlayButton.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: 5),
            
            
            heartButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 4),
            heartButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -10),
            heartButton.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -10),
            heartButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            //            playButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 2),
        ])
        
        
        for image in song.images {
            if image.height == 300 {
                cellImage.kf.setImage(with: image.url) { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let value):
                        
                        DispatchQueue.main.async {
                            self.cellImage.image = value.image
                            self.label.text = song.title
                            
                        }
                    }
                    
                }
            }
        }
    }
    
}


class Player {
    
    static let shared = Player()
    var player: AVAudioPlayer!
    var isPlaying = false
    
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
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
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
    
    func pause() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
}
