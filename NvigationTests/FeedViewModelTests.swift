//
//  FeedViewModelTests.swift
//  NvigationTests
//
//  Created by Ilya Maenkov on 09.04.2024.
//

import XCTest
@testable import Nvigation

final class FeedViewModelTests: XCTestCase {
    
    var feedModel: FeedModel!
    
    override func setUpWithError() throws {
        feedModel = FeedModel(secretWord: "test")
    }

    override func tearDownWithError() throws {
        feedModel = nil
    }

    func testCorrectWord() throws {
        let result = feedModel.check("test")
        XCTAssertTrue(result, "secret word is correct")
    }

    
    func testWrongWord() {
        let result = feedModel.check("wrongWord")
        XCTAssertFalse(result, "secret word is wrong")
    }
    
    func testEmpty() {
        let result = feedModel.check("")
        XCTAssertFalse(result, "no word")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
