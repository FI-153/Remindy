//
//  ExtensionsTests.swift
//  MinimalReminderAppTests
//
//  Created by Federico Imberti on 26/04/22.
//

import XCTest
import SwiftUI
@testable import Remindy

class ExtensionsTests: XCTestCase {

    func test_Extensions_empty_anEmptyStringIsProduced() {
        // Given
        let emptyString = ""

        // When
        // Then
        XCTAssertEqual(emptyString, String.empty)
    }

    func test_Extensions_uppercaseFirstLetter_theFirstLetterOfTheStringIsUppercased() {
        // Given
        let emptyString = "hello world"
        let expectedString = "Hello world"

        // When
        // Then
        XCTAssertEqual(emptyString.uppercaseFirstLetter(), expectedString)

    }
/*
    func test_Extensions_incresedByDays_theDateIsIncresedByThreeDays() {
        // Given
        let datePlusThreeDays = Date.now.addingTimeInterval(3*86400)

        // When
        let addedDate = Date.now.increasedBy(days: "3")

        // Then
        XCTAssertEqual(addedDate, datePlusThreeDays)
    }

    func test_Extensions_incresedByMinutes_theDateIsIncresedByThreeMinutes() {
        // Given
        let datePlusThreeMinutes = Date.now.addingTimeInterval(3*60)

        // When
        let addedDate = Date.now.increasedBy(minutes: "3")

        // Then
        XCTAssertEqual(addedDate, datePlusThreeMinutes)
    }

    func test_Extensions_incresedByHours_theDateIsIncresedByThreeHours() {
        // Given
        let datePlusThreeHours = Date.now.addingTimeInterval(3*3600)

        // When
        let addedDate = Date.now.increasedBy(hours: "3")

        // Then
        XCTAssertEqual(addedDate, datePlusThreeHours)
    }
*/
    func test_Extensions_toRGBA_conversionIsCorrect() {
        // Given
        let color = Color.red
        let colorRGBA: [Float] = [1.0, 0.25882354, 0.27058825]

        // When
        let colorGettedComponents = color.toRGB()

        // Then
        XCTAssertEqual(colorRGBA, colorGettedComponents)
    }

}
