//
//  LoginViewModelTest.swift
//  NvigationTests
//
//  Created by Ilya Maenkov on 06.04.2024.
//

import XCTest
@testable import Nvigation

final class LogInViewControllerTests: XCTestCase {

    var viewController: LogInViewController?
    var delegate = MockLoginViewControllerDelegate()
    let mockCheckerService = MockCheckerService()

    override func setUpWithError() throws {
        viewController = LogInViewController(viewModel: ProfileViewModel(service: mockCheckerService))
        viewController?.loginDelegate = delegate
    }

    override func tearDownWithError() throws {
        viewController = nil
    }

    //MARK: - Tests
    
    func testTapLogInWithValidCredentials() {
       
        let expectedLogin = "test@test.ru"
        let expectedPassword = "password123"
        viewController?.logInTextField.text = expectedLogin
        viewController?.passwordTextField.text = expectedPassword

        viewController?.tapLogIn()

        XCTAssertTrue(delegate.didCallCheckMethod)
        XCTAssertEqual(delegate.receivedEmail, expectedLogin)
        XCTAssertEqual(delegate.receivedPassword, expectedPassword)
    }

    func testTapLogInWithEmptyFields() {
    
        viewController?.logInTextField.text = ""
        viewController?.passwordTextField.text = ""

        viewController?.tapLogIn()

        XCTAssertFalse(delegate.didCallCheckMethod)
    }

    func testTapLogInWithInvalidCredentials() {
     
        let invalidEmail = "invalid_email"
        let invalidPassword = "short"
        viewController?.logInTextField.text = invalidEmail
        viewController?.passwordTextField.text = invalidPassword

        viewController?.tapLogIn()

        XCTAssertTrue(delegate.didCallCheckMethod)
        XCTAssertEqual(delegate.receivedEmail, invalidEmail)
        XCTAssertEqual(delegate.receivedPassword, invalidPassword)
    }
}

//MARK: - Mocks

final class MockLoginViewControllerDelegate: LoginViewControllerDelegate {
    var didCallCheckMethod = false
    var receivedEmail: String?
    var receivedPassword: String?

    func check(login email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        didCallCheckMethod = true
        receivedEmail = email
        receivedPassword = password
    }

    func signUp(_ login: String, _ password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        
    }
}

final class MockCheckerService: CheckerServiceProtocol {
    var shouldSimulateSuccess = true
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        if shouldSimulateSuccess {
            completion(.success(()))
        } else {
            completion(.failure(.unknown))
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        if shouldSimulateSuccess {
            completion(.success(()))
        } else {
            completion(.failure(.unknown))
        }
    }
}


