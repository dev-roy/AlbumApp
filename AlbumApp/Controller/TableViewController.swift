//
//  TableViewController.swift
//  AlbumApp
//
//  Created by Field Employee on 4/3/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import NVActivityIndicatorView

class TableViewController: UIViewController, NVActivityIndicatorViewable {
    // MARK: - Properties
    var albums = [Album]()
    @IBOutlet weak var albumsTableView: UITableView!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        getAlbums()
    }
    
    // MARK: - Networking
    func getAlbums() {
       startAnimating(CGSize(width: 60, height: 60), type: NVActivityIndicatorType.ballTrianglePath, color: UIColor.red)
            DispatchQueue.global(qos: .background).async {
            AF.request("http://jsonplaceholder.typicode.com/photos").validate().responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    let json: JSON = JSON(data)
                    for (_, object) in json {
                        let album = Album()
                        album.title = object["title"].stringValue
                        album.url = object["url"].stringValue
                        album.thumbnailURL = object["thumbnailUrl"].stringValue
                        self.albums.append(album)
                        print(album.thumbnailURL, "test")
                    }
                    DispatchQueue.main.async {
                        self.albumsTableView.reloadData()
                        self.stopAnimating()
                    }
                    
                    case .failure(let error):
                        print(error)
                        self.stopAnimating()
                        break
                    }
                }
            }
    }
}

// MARK: - Handlers
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
        if let indexPath = albumsTableView.indexPathForSelectedRow {
            let album = albums[indexPath.row]
            let controller = segue.destination as! AlbumDetailViewController
            controller.detailAlbum = album
        }
    }
}

// MARK: - Extensions

// MARK: - TableView methods
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let imageURL: URL? = URL(string: albums[indexPath.row].thumbnailURL)
        if let url = imageURL {
            cell.albumImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.albumImage.sd_setImage(with: url, placeholderImage: UIImage(named: "white"))
        }
        cell.albumTitle.text = albums[indexPath.row].title
        return cell
    }
}
