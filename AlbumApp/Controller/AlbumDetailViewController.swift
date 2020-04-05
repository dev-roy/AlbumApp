//
//  AlbumDetailViewController.swift
//  AlbumApp
//
//  Created by Field Employee on 4/3/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import SDWebImage

class AlbumDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var detailAlbumImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    var detailAlbum: AlbumViewModel? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        configureView()
    }
    
    func configureView() {
        if let album = detailAlbum {
            if let detailImage = detailAlbumImage {
                let imageURL: URL? = URL(string: album.url)
                if let url = imageURL {
                    detailImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    detailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "white"))
                }
            }
            if let title = albumTitle {
                title.text = album.title
            }
        }
    }
    
    // MARK: - Deinit
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Handlers
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            titleTopConstraint.constant = -100
            doneButton.isHidden = false
        } else {
            titleTopConstraint.constant = 35
            doneButton.isHidden = true
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
