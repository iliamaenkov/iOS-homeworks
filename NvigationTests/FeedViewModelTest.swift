//
//  FeedViewModelTest.swift
//  NvigationTests
//
//  Created by Ilya Maenkov on 06.04.2024.
//

import XCTest
@testable import Nvigation

final class FeedModelTests: XCTestCase {
    
    let feedModel = FeedModel(secretWord: "test")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: - Tests
    
    func testCorrectWord() {
        let result = feedModel.check("test")
        XCTAssertEqual(result, true)
    }
    
    func testIncorrectWord() {
        let result = feedModel.check("wrong")
        XCTAssertEqual(result, false)
    }
    
    func testMissingWord() {
        let result = feedModel.check("")
        XCTAssertEqual(result, false)
    }
}
