//
//  NetworkManager.swift
//  AlbumApp
//
//  Created by Field Employee on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchAlbums(completion:@escaping(_ success: Bool, _ arr: [Album])->()) {
        DispatchQueue.global(qos: .background).async {
            AF.request("http://jsonplaceholder.typicode.com/photos").validate().responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    let json: JSON = JSON(data)
                    var albumsArray = [Album]()
                    for (_, object) in json {
                        let album = Album(title: object["title"].stringValue, thumbnailURL: object["thumbnailUrl"].stringValue, url: object["url"].stringValue)
                        albumsArray.append(album)
                    }
                    completion(true, albumsArray)
                    
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
            }
    }
}
