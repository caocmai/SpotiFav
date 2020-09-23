//
//  Client.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/22/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct Client {
    //    static private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    public func call(request: RequestFinal) {
        let urlRequest = request.builder.toURLRequest()
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            let result: Result<Data, Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(data ?? Data())
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                  print(jsonObject)
            } catch {
                print("error with data task")
                print(error.localizedDescription)
            }
                               
            
            DispatchQueue.main.async {
                request.completion(result)
            }
        }.resume()
    }
    
    static func getAccessCodeURL() -> URL {
        let accessCodeBaseURL = "https://accounts.spotify.com/"

        let paramDictionary = ["client_id" : SpotifyNetworkLayer.SPOTIFY_API_CLIENT_ID,
                               "redirect_uri" : SpotifyNetworkLayer.REDIRECT_URI,
                               "response_type" : SpotifyNetworkLayer.RESPONSE_TYPE,
                               "scope" : SpotifyNetworkLayer.SCOPE.joined(separator: "%20")
        ]

        let mapToHTMLQuery = paramDictionary.map { key, value in

            return "\(key)=\(value)"
        }


        let stringQuery = mapToHTMLQuery.joined(separator: "&")

        let fullURL = URL(string: accessCodeBaseURL.appending("?\(stringQuery)"))

        return fullURL!

    }
    
}
