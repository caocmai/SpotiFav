//
//  SearchTableViewController.swift
//  SpotiFav
//
//  Created by Cao Mai on 10/12/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var searchTerm: String!
    var searchType: SpotifyType!
    private let api = APIClient(configuration: .default)
    var artists: [ArtistItem] = []
    private var simplifiedTracks = [SimpleTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.navigationItem.title = (searchType.rawValue + "s:").capitalized + " " + searchTerm.capitalized
        tableView.register(TableCell.self, forCellReuseIdentifier: String(describing: type(of: TableCell.self)))
        
        let token = (UserDefaults.standard.string(forKey: "token"))
        //        print(token)
        api.call(request: .search(token: token!, q: searchTerm, type: searchType) { result in
            
            switch self.searchType {
            case .artist:
                let artists = result as? Result<SearchArtists, Error>
                
                switch artists {
                case .success(let something):
                    self.artists = something.artists.items
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                    
                case .failure(let error):
                    print(error)
                case .none:
                    print("not decoding correctly")
                }
                
            case .track:
                let tracks = result as? Result<SearchTracks, Error>
                
                switch tracks {
                case .success(let something):
                    for track in something.tracks.items {
                        let newTrack = SimpleTrack(artistName: track.album.artists.first?.name, id: track.id, title: track.name, previewURL: track.previewUrl, images: track.album.images!)
                        self.simplifiedTracks.append(newTrack)
                    }
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                case .none:
                    print("not decoding correctly")
                }
                
                
            default:
                print("type not implemented yet")
                
            }
            
            
            })
        
        //        print(token)
        
        //        api.call(request: .search(token: token!, q: "Moe", type: .artist))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch searchType {
        case .artist:
            return artists.count
        case .track:
            return simplifiedTracks.count
        default:
            print("return 0")
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: TableCell.self))) as! TableCell
        
        switch searchType {
        case .artist:
            cell.accessoryType = .disclosureIndicator
            cell.setArtist(artist: artists[indexPath.row])
        case .track:
            cell.setTrack(song: simplifiedTracks[indexPath.row], hideHeartButton: false)
            cell.simplifiedTrack = simplifiedTracks[indexPath.row]
        default:
            print("nothing to render in cell")
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchType == .artist {
            let artist = artists[indexPath.row]
            
            let destinationVC = ArtistTopTracksVC()
            destinationVC.artist = artist
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
