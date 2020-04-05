//
//  AlbumDetailViewController.swift
//  AlbumApp
//
//  Created by Field Employee on 4/3/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import SDWebImage
import Lightbox

class AlbumDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var detailAlbumImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageButtonTopConstraint: NSLayoutConstraint!    
    @IBOutlet weak var doneButtonTopConstraint: NSLayoutConstraint!
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
        detectOrientation()
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
        detectOrientation()
    }
    
    func setPortraitModeConstraints() {
        titleTopConstraint.constant = 35
        imageTopConstraint.constant = 100
        imageButtonTopConstraint.constant = 100
        doneButtonTopConstraint.constant = 45
    }
    
    func setLandscapeModeConstraints() {
        titleTopConstraint.constant = -100
        imageTopConstraint.constant = 50
        imageButtonTopConstraint.constant = 50
        doneButtonTopConstraint.constant = 18
    }
    
    func detectOrientation() {
        if UIDevice.current.orientation.isLandscape {
            setLandscapeModeConstraints()
        } else {
            setPortraitModeConstraints()
        }
    }
    
    @IBAction func detailImagePressed(_ sender: Any) {
        if let album = detailAlbum {
            let imageURL: URL? = URL(string: album.url)
            if let url = imageURL {
                let images = [LightboxImage(imageURL: url)]
                let controller = LightboxController(images: images)
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: true, completion: nil)
            }
            
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
