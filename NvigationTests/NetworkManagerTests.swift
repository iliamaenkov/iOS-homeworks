//
//  NetworkManagerTests.swift
//  NvigationTests
//
//  Created by Ilya Maenkov on 06.04.2024.
//

import XCTest
@testable import Nvigation

final class NetworkManagerTests: XCTestCase {
    
    var fakeClient: FakeNetworkClient! = nil
    
    override func setUpWithError() throws {
        fakeClient = FakeNetworkClient(fakeResponse: .empty)
    }
    
    override func tearDownWithError() throws {
        fakeClient = nil
    }
    
    //MARK: - Tests
    
    func testSuccessfulRequest() {
          fakeClient.fakeResponse = .success("Fake Data".data(using: .utf8)!)
          let url = URL(string: "https://example.com")!
          
          NetworkManager.request(url: url) { result in
              switch result {
              case .success(let response):
                  XCTAssertEqual(response.dataString, "Fake Data")
              case .failure:
                  XCTFail("Expected success response")
              }
          }
      }

      func testRequestWithError() {
          fakeClient.fakeResponse = .failure(.custom(description: "Fake Error"))
          let url = URL(string: "https://example.com")!
          
          NetworkManager.request(url: url) { result in
              switch result {
              case .success:
                  XCTFail("Expected failure response")
              case .failure(let error):
                  XCTAssertEqual(error.localizedDescription, "Fake Error")
              }
          }
      }
      
      func testEmptyResponse() {
          fakeClient.fakeResponse = .empty
          let url = URL(string: "https://example.com")!
          
          NetworkManager.request(url: url) { result in
              switch result {
              case .success:
                  XCTFail("Expected failure response")
              case .failure(let error):
                  XCTAssertEqual(error as! NetworkError, NetworkError.server)
              }
          }
      }
}

//MARK: - Mocks

final class FakeNetworkClient: INetworkClient {
    enum FakeResponse {
        case success(Data)
        case failure(NetworkError)
        case empty
    }
    
    var fakeResponse: FakeResponse
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    
    func request(with urlRequest: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        switch fakeResponse {
        case .success(let data):
            completion(.success(data))
        case .failure(let error):
            completion(.failure(error))
        case .empty:
            completion(.failure(.server))
        }
    }
}
