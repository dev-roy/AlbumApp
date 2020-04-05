//
//  CollectionViewController.swift
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

class CollectionViewController: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - Properties
    @IBOutlet weak var albumCollection: UICollectionView!
    var albumViewModels = [AlbumViewModel]()
    var albums = [Album]()
    var isLoading = false
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlbums()
    }
    
    // MARK: - Networking
    func loadAlbums() {
        startAnimating(CGSize(width: 60, height: 60), type: NVActivityIndicatorType.ballTrianglePath, color: UIColor.red)
        NetworkManager.shared.fetchAlbums { (success, albums) in
            if success {
                self.albums = albums
                self.albumViewModels = albums.map({return AlbumViewModel(album: $0)})
                DispatchQueue.main.async {
                    self.albumCollection.reloadData()
                    self.stopAnimating()
                }
            } else {
                print("error")
                self.stopAnimating()
            }
        }
    }
    
    // MARK: - Handlers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFromCollection" {
            if let indexPath = albumCollection.indexPath(for: sender as! UICollectionViewCell) {
                let album = albumViewModels[indexPath.row]
                let controller = segue.destination as! AlbumDetailViewController
                controller.detailAlbum = album
            }
        }
    }
    
}

// MARK: - Extensions

//MARK: - CollectionView methods
extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        let url = URL(string: albumViewModels[indexPath.row].thumbnailURL)
        DispatchQueue.main.async {
            if let imageURL = url {
                cell.albumImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.albumImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "white"))
            }
        }
        return cell
    }

}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: (screenWidth / 6) - 2, height: (screenWidth / 6) - 2)
        } else {
            return CGSize(width: (screenWidth / 3) - 1, height: (screenWidth / 3) - 1)
        }
    }
}
