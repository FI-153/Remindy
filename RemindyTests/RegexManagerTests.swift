//
//  RegexManagerTests.swift
//  RemindyTests
//
//  Created by Federico Imberti on 11/06/22.
//

import XCTest
@testable import Remindy

class RegexManagerTests: XCTestCase {
    
    var regexManager:RegexManager!

    override func setUpWithError() throws {
        regexManager = RegexManager()
    }

    override func tearDownWithError() throws {
        regexManager = nil
    }

    func test_DateEngine_validateReminderSection_allPhrasesAreCorrect() {
        // Given
        let correctPhrases = ["tomorrow at 8 pm",
                              "tomorrow at 8.59 pm",
                              "today at 8 pm",
                              "in 3 days at 8.12 am",
                              "in 3 days at 8.12am",
                              "in 3 days at 8.59 pm",
                              "in 1 minute",
                              "in 3 minutes",
                              "in 3 hours",
                              "in 3 days at 8.59 PM"]

        for phrase in correctPhrases {
            // When
            let isPhraseCorrect = regexManager.validateReminderSection(phrase)
            
            // Then
            XCTAssertTrue(isPhraseCorrect)
        }
    }

    func test_DateEngine_validateReminderSection_allPhrasesAreWrong() {
        // Given
        let wrongPhrases = [
                            "tomorrow at 8.60 pm",
                            "in 4 days at 9.124 am",
                            "in",
                            "in 4",
                            "in 4 days",
                            "in 3 days at",
                            "in 3 days at 2",
                            "today at 13.29 pm",
                            "in f dyasi",
                            "in gerg minute",
                            "in 3 minuts",
                            "in3 hours",
                            "in 3 days",
                            "tomorrow",
                            "tomorrow at",
                            "tomorrow at x",]

        for phrase in wrongPhrases {
            // When
            let isPhraseCorrect = regexManager.validateReminderSection(phrase)

            // Then
            XCTAssertFalse(isPhraseCorrect)
        }
    }


}
