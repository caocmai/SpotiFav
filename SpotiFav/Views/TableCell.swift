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
    let artistLabel = UILabel()
    let cellImage = UIImageView()
    
    var simplifiedTrack: SimpleTrack!
    
    lazy var heartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
//        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let playbackImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let play = UIImage(systemName: "play.fill")
        let playGray = play?.withTintColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), renderingMode: .alwaysOriginal)
        image.image = playGray
        return image
    }()
    
    lazy var hiddenPlayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hiddenPlayButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var currentPlayingId: String? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        currentPlayingId = UserDefaults.standard.string(forKey: "current_playing_id")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /// To give spacing between cells
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 2, right: 0))
    }
    
    @objc func heartTapped() {
        var favArrayIds = [String]()
        
        favArrayIds = UserDefaults.standard.stringArray(forKey: "favTracks") ?? [String]()
        print(favArrayIds)
        if !favArrayIds.contains(simplifiedTrack.id) {
            print("doesn't have id")
            let heart = UIImage(systemName: "heart.fill")
            let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
            heartButton.setImage(redHeartColor, for: .normal)
            favArrayIds.append(simplifiedTrack.id)
        } else {
            print("have id")
            favArrayIds = favArrayIds.filter(){$0 != simplifiedTrack.id}
            let heart = UIImage(systemName: "heart")
            let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
            heartButton.setImage(redHeartColor, for: .normal)
            
        }
        print(favArrayIds)
        
        UserDefaults.standard.set(favArrayIds, forKey: "favTracks")
        
    }
    
    @objc func hiddenPlayButtonTapped() {
        
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
                let playGray = play?.withTintColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), renderingMode: .alwaysOriginal)
                playbackImage.image = playGray
                
            } else {
                player.play()
                let play = UIImage(systemName: "pause.fill")
                let playGray = play?.withTintColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), renderingMode: .alwaysOriginal)
                playbackImage.image = playGray
                
            }
            
        }
        
    }
    
    fileprivate func configureCell(hideHeartButton: Bool?, hidePlayButton: Bool?) {
        label.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        
        artistLabel.font = UIFont.systemFont(ofSize: 11.5)
        artistLabel.textColor = .gray
        
        self.contentView.addSubview(heartButton)
        self.contentView.addSubview(label)
        self.contentView.addSubview(artistLabel)
        self.contentView.addSubview(cellImage)
        self.contentView.addSubview(hiddenPlayButton)
        self.contentView.addSubview(playbackImage)
        
        cellImage.contentMode = .scaleAspectFit
        
        // To hide just heartButton
        if hideHeartButton! && !hidePlayButton! {
            //            print("hide one")
            heartButton.isHidden = true
            NSLayoutConstraint.activate([
                cellImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                hiddenPlayButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            ])
        } else if hideHeartButton! && hidePlayButton! { // To hide both heart and playback button
            //            print("hide both")
            heartButton.isHidden = true
            hiddenPlayButton.isHidden = true
            artistLabel.isHidden = true
            playbackImage.isHidden = true
            NSLayoutConstraint.activate([
                cellImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            ])
        } else {
            //            print("hide none")
            NSLayoutConstraint.activate([
                cellImage.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor),
                hiddenPlayButton.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor),
            ])
        }
        
        NSLayoutConstraint.activate([
            
            heartButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            heartButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            heartButton.widthAnchor.constraint(equalTo: self.contentView.heightAnchor),
            heartButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            //            cellImage.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor),
            
            cellImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            cellImage.widthAnchor.constraint(equalTo: self.contentView.heightAnchor),
            
            label.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -40),
            
            //            hiddenPlayButton.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor),
            
            hiddenPlayButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            hiddenPlayButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            artistLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            artistLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 8),
            
            playbackImage.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            playbackImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -45),
            playbackImage.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -45),
            playbackImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
        ])
        
    }
    
    internal func setTrack(song: SimpleTrack, hideHeartButton: Bool) {
        
        configureCell(hideHeartButton: hideHeartButton, hidePlayButton: false)
        
        if song.previewUrl == nil {
            hiddenPlayButton.isHidden = true
            playbackImage.isHidden = true
            
        } else {
            hiddenPlayButton.isHidden = false
            playbackImage.isHidden = false
        }
        
        var favArrayIds = [String]()
        favArrayIds = UserDefaults.standard.stringArray(forKey: "favTracks") ?? [String]()
        
        if !hideHeartButton {
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
        }
        
        
        if let player = AudioPlayer.shared.player {
            if player.isPlaying {
                if currentPlayingId == song.id {
                    let play = UIImage(systemName: "pause.fill")
                    let playGray = play?.withTintColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), renderingMode: .alwaysOriginal)
                    playbackImage.image = playGray
                } else {
                    let play = UIImage(systemName: "play.fill")
                    let playGray = play?.withTintColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), renderingMode: .alwaysOriginal)
                    playbackImage.image = playGray
                }
                
            }
        }
        
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
                            self.artistLabel.text = song.artistName
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    internal func setArtist(artist: ArtistItem) {
        configureCell(hideHeartButton: true, hidePlayButton: true)
        
        for image in artist.images {
            if image.height == 160 {
                cellImage.kf.setImage(with: image.url, options: []) { result in
                    switch result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            self.label.text = artist.name
                            self.cellImage.image = value.image
                        }
                    case .failure(let error):
                        print(error)
                    }
                    
                }
                
            }
        }
    }
    
    
}
