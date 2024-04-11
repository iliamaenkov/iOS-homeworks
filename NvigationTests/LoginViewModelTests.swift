//
//  LoginViewModelTests.swift
//  NvigationTests
//
//  Created by Ilya Maenkov on 09.04.2024.
//

import XCTest
@testable import Nvigation

final class LogInViewControllerTests: XCTestCase {

    var viewModel: ProfileViewModel!
    var loginController: LogInViewController!
    var mockDelegate: MockLoginViewControllerDelegate!

    override func setUpWithError() throws {
        viewModel = ProfileViewModel(service: CheckerService())
        mockDelegate = MockLoginViewControllerDelegate()
        loginController = LogInViewController(viewModel: viewModel)
        loginController.loginDelegate = mockDelegate
    }

    override func tearDownWithError() throws {
        viewModel = nil
        loginController = nil
        mockDelegate = nil
    }

    func testLogin() {
        let expectedLogin = "test@test.ru"
        let expectedPassword = "password123"
        
        loginController.logInTextField.text = expectedLogin
        loginController.passwordTextField.text = expectedPassword
        loginController.tapLogIn()

        XCTAssertTrue(mockDelegate.didCallCheckMethod)
        XCTAssertEqual(mockDelegate.receivedEmail, expectedLogin)
        XCTAssertEqual(mockDelegate.receivedPassword, expectedPassword)
    }

    func testEmptyCredentials() {
        let expectedLogin = ""
        let expectedPassword = ""
        
        loginController.logInTextField.text = expectedLogin
        loginController.passwordTextField.text = expectedPassword
        loginController.tapLogIn()

        XCTAssertFalse(mockDelegate.didCallCheckMethod)
    }
    
    func testShortPassword() {
        let expectedLogin = "user@test.com"
        let expectedPassword = "123"
        
        loginController.logInTextField.text = expectedLogin
        loginController.passwordTextField.text = expectedPassword
        loginController.tapSignUp()

        XCTAssertFalse(mockDelegate.didCallCheckMethod)
        XCTAssertEqual(mockDelegate.receivedEmail, expectedLogin)
        XCTAssertEqual(mockDelegate.receivedPassword, expectedPassword)
    }
}



final class MockLoginViewControllerDelegate: LoginViewControllerDelegate {
    var didCallCheckMethod = false
    var receivedEmail: String?
    var receivedPassword: String?

    func check(login email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        didCallCheckMethod = true
        receivedEmail = email
        receivedPassword = password
        
        completion(.success(()))
    }

    func signUp(_ login: String, _ password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        didCallCheckMethod = false
        receivedEmail = login
        receivedPassword = password
        
        completion(.success(()))
    }
}
