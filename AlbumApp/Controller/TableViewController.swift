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
    var albumViewModels = [AlbumViewModel]()
    @IBOutlet weak var albumsTableView: UITableView!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlbums()
    }
    
    // MARK: - Handlers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = albumsTableView.indexPathForSelectedRow {
                let album = albumViewModels[indexPath.row]
                let controller = segue.destination as! AlbumDetailViewController
                controller.detailAlbum = album
            }
        }
    }
    
    // MARK: - Networking
    func loadAlbums() {
        startAnimating(CGSize(width: 60, height: 60), type: NVActivityIndicatorType.ballTrianglePath, color: UIColor.red)
        NetworkManager.shared.fetchAlbums { (success, albums) in
            if success {
                self.albumViewModels = albums.map({return AlbumViewModel(album: $0)})
                DispatchQueue.main.async {
                    self.albumsTableView.reloadData()
                    self.stopAnimating()
                }
            } else {
                print("error")
                self.stopAnimating()
            }
        }
    }
}


// MARK: - Extensions

// MARK: - TableView methods
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let imageURL: URL? = URL(string: albumViewModels[indexPath.row].thumbnailURL)
        if let url = imageURL {
            cell.albumImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.albumImage.sd_setImage(with: url, placeholderImage: UIImage(named: "white"))
        }
        cell.albumTitle.text = albumViewModels[indexPath.row].title
        return cell
    }
}
