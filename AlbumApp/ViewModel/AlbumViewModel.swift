//
//  AlbumViewModel.swift
//  AlbumApp
//
//  Created by Field Employee on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

struct AlbumViewModel {
    let title: String
    let url: String
    let thumbnailURL: String
    
    init(album: Album){
        self.title = album.title
        self.url = album.url
        self.thumbnailURL = album.thumbnailURL
    }
    
    
}
