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
    
    lazy var heartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let heart = UIImage(systemName: "heart")
        let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
        button.setImage(redHeartColor, for: .normal)
        button.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let play = UIImage(systemName: "play.fill")
        button.setImage(play, for: .normal)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        contentView.backgroundColor = .red
        
        // Configure the view for the selected state
    }
    
    @objc func heartTapped() {
        let heart = UIImage(systemName: "heart.fill")
        let redHeartColor = heart?.withTintColor(#colorLiteral(red: 0.8197939992, green: 0, blue: 0.02539807931, alpha: 1), renderingMode: .alwaysOriginal)
        heartButton.setImage(redHeartColor, for: .normal)
        
        
    }
    
    func setTrack(track: Item) {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(heartButton)
        self.contentView.addSubview(label)
        self.contentView.addSubview(cellImage)
        self.contentView.addSubview(playButton)
        
        
        cellImage.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            
            //            playButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
            //            playButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            //            playButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),
            //            playButton.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),
            
            
            playButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            playButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            playButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),
            playButton.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),
            
            
            
            cellImage.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 10),
            //            cellImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            cellImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            cellImage.widthAnchor.constraint(equalTo: self.contentView.heightAnchor),
            
            label.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 30),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50),
            //
            heartButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4),
            heartButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -10),
            heartButton.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -10),
            heartButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            
            
            
            
            //            playButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 2),
            
            
        ])
        
        for image in track.track.album!.images {
            if image.height == 300 {
                cellImage.kf.setImage(with: image.url) { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let value):
                        
                        DispatchQueue.main.async {
                            self.cellImage.image = value.image
                            self.label.text = track.track.name
                            
                        }
                    }
                    
                }
            }
        }
        
        
        
        
    }
    
}
