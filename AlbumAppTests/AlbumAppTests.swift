//
//  AlbumAppTests.swift
//  AlbumAppTests
//
//  Created by Field Employee on 4/5/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import XCTest
@testable import AlbumApp

class AlbumAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAlbumViewModel() {
        let album = Album(title: "This is the title", thumbnailURL: "https://www.google.com/thmbnailImage.png", url: "https://www.google.com/image.png")
        let albumViewModel = AlbumViewModel(album: album)
        XCTAssertEqual(album.title, albumViewModel.title)
        XCTAssertEqual(album.url, albumViewModel.url)
        XCTAssertEqual(album.thumbnailURL, albumViewModel.thumbnailURL)
    }

}
