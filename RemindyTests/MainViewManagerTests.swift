//
//  MainViewManagerTests.swift
//  MinimalReminderAppTests
//
//  Created by Federico Imberti on 26/04/22.
//

import XCTest
@testable import Remindy

class MainViewManagerTests: XCTestCase {

    var vm: MainViewModel!

    override func setUpWithError() throws {
        vm = MainViewModel()
    }

    override func tearDownWithError() throws {
        vm = nil
    }

    func test_MainViewModel_clerTypedText_theTextIsCleared() {
        // Given
        vm.newItemName = "gergq123124@!#$$"

        // When
        vm.clerTypedText()

        // Then
        XCTAssertTrue(vm.newItemName.isEmpty)

    }

}
