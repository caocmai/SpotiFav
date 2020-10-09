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
        
        var downloadTask: URLSessionDownloadTask

        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self] (URL, response, error) in
            
            if let url = URL {
                self?.play(url: url)

            }

        })

        downloadTask.resume()
        
        
//        URLSession.shared.downloadTask(with: url) { (url, response, error) in
//            self.play(url: url!)
//        }.resume()
        
    }
    
    func play(url: URL) {
        print("playing \(url)")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            //            player.prepareToPlay()
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            player.play()
            player.volume = 0.6

        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
}
