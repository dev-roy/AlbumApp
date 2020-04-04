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
    var albums = [Album]()
    var isLoading = false
    
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
                    }
                    DispatchQueue.main.async {
                        self.albumCollection.reloadData()
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
    
    // MARK: - Handlers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFromCollection" {
            if let indexPath = albumCollection.indexPath(for: sender as! UICollectionViewCell) {
                let album = albums[indexPath.row]
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
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        let url = URL(string: albums[indexPath.row].thumbnailURL)
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
