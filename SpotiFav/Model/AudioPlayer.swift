//
//  AudioPlayer.swift
//  SpotiFav
//
//  Created by Cao Mai on 10/4/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {
    
    static let shared = AudioPlayer()
    var player: AVAudioPlayer!
    
    func downloadFileFromURL(url: URL){
        //URLSessionDownloadTask
        URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (URL, response, error) in
            
            if let url = URL {
                self?.play(url: url)
                
            }
        }).resume()
    }
    
    func play(url: URL) {
        //        print("playing \(url)")
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            // to be able to play sound when device in slient mode
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            player.play()
            player.volume = 0.7
            
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
}
