//
//  TableCell.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/24/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit

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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        favArrayIds = UserDefaults.standard.stringArray(forKey: "favTracks") ?? [String]()
        //        print(favArrayIds)
        
        currentPlayingId = UserDefaults.standard.string(forKey: "current_playing_id")
        //        isPlaying = UserDefaults.standard.bool(forKey: "isPlaying")
        //        print(isPlaying)
        
    }
    
    @objc func heartTapped() {
        var favArrayIds = [String]()
        
        favArrayIds = UserDefaults.standard.stringArray(forKey: "favTracks") ?? [String]()

        if !favArrayIds.contains(simplifiedTrack.id) {
            print("doesn't have id")
            let heart = UIImage(systemName: "heart.fill")
            let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
            heartButton.setImage(redHeartColor, for: .normal)
            favArrayIds.append(simplifiedTrack.id)
            UserDefaults.standard.set(favArrayIds, forKey: "favTracks")
        } else {
            print("have id")
            favArrayIds.remove(element: simplifiedTrack.id)
            let heart = UIImage(systemName: "heart")
            let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
            heartButton.setImage(redHeartColor, for: .normal)
            UserDefaults.standard.set(favArrayIds, forKey: "favTracks")

        }
        
    }
    
    @objc func hiddenPlayButtonTapped() {
        //        print(currentPlayingId)
        
        if AudioPlayer.shared.player == nil {
            print("player not playing")
            if let previewURL = simplifiedTrack.previewUrl {
                AudioPlayer.shared.downloadFileFromURL(url: previewURL)
            }
            currentPlayingId = simplifiedTrack.id
            UserDefaults.standard.set(currentPlayingId, forKey: "current_playing_id")
            let play = UIImage(systemName: "pause.fill")
            let playGray = play?.withTintColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), renderingMode: .alwaysOriginal)
            playbackImage.image = playGray
            
        }
        
        
        if currentPlayingId != simplifiedTrack.id {
            if let previewURL = simplifiedTrack.previewUrl {
                AudioPlayer.shared.downloadFileFromURL(url: previewURL)
            }
            currentPlayingId = simplifiedTrack.id
            UserDefaults.standard.set(currentPlayingId, forKey: "current_playing_id")
            
            DispatchQueue.main.async {
                let play = UIImage(systemName: "pause.fill")
                let playGray = play?.withTintColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), renderingMode: .alwaysOriginal)
                self.playbackImage.image = playGray
            }
            
        }
        
        if let player = AudioPlayer.shared.player {
            if player.isPlaying {
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

        label.translatesAutoresizingMaskIntoConstraints = false
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        var favArrayIds = [String]()
        favArrayIds = UserDefaults.standard.stringArray(forKey: "favTracks") ?? [String]()

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
        
        
        if let player = AudioPlayer.shared.player {
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
            
             heartButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
             heartButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
             heartButton.widthAnchor.constraint(equalTo: self.contentView.heightAnchor),
             heartButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            cellImage.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor),
            cellImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            cellImage.widthAnchor.constraint(equalTo: self.contentView.heightAnchor),
            
            label.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -40),
            
            hiddenPlayButton.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor),
            hiddenPlayButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            hiddenPlayButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            playbackImage.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            playbackImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -40),
            playbackImage.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -40),
            playbackImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
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


extension Array where Element: Equatable{
    mutating func remove (element: Element) {
        if let i = self.firstIndex(of: element) {
            self.remove(at: i)
        }
    }
}
