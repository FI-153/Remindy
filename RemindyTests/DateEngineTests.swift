//
//  DateEngineTests.swift
//  MinimalReminderAppTests
//
//  Created by Federico Imberti on 27/04/22.
//

import XCTest
@testable import Remindy

class DateEngineTests: XCTestCase {

    var dateEngine: DateEngine!

    override func setUpWithError() throws {
        dateEngine = DateEngine()
    }

    override func tearDownWithError() throws {
        dateEngine = nil
    }

    func test_DateEngine_tokenize_theStringIsTokenized() {
        // Given
        let phrase = "Hello, how are you?"
        let exprectedTokenizedPhrase = ["hello,", "how", "are", "you?"]

        // When
        let tokenizedPhrase = dateEngine.tokenize(phrase, using: " ")

        // Then
        XCTAssertEqual(exprectedTokenizedPhrase, tokenizedPhrase)
    }

    func test_DateEngine_findWordWithComma_theWordWithCommaIsFound() {
        // Given
        let tokenizedPhrase = ["hello,", "how", "are", "you?"]

        // When
        let wordWithComam = dateEngine.findWordWithComma(in: tokenizedPhrase)

        // Then
        XCTAssertEqual(wordWithComam, "hello,")
    }

    func test_DateEngine_findIndexOfWordWithComma_theFirstIndexOfTheArrayIsGiven() {
        // Given
        let tokenizedPhrase = ["hello,", "how", "are", "you?"]

        // When
        let index = dateEngine.findIndexOfWordWithComma(of: tokenizedPhrase)

        // Then
        XCTAssertEqual(index, 0)
    }

    func test_DateEngine_findIndexOfWordWithComma_noIndexIsGiven() {
        // Given
        let tokenizedPhrase = ["hello", "how", "are", "you?"]

        // When
        let index = dateEngine.findIndexOfWordWithComma(of: tokenizedPhrase)

        // Then
        XCTAssertNil(index)
    }

    func test_DateEngine_getTimeAndAmpm_givenTimeHasNoMinutes() {
        // Given
        let tokenizedPhrase = ["today", "at", "8", "pm"]

        // When
        let (time, amPm) = dateEngine.getTimeAndAmpm(from: tokenizedPhrase, strartingFrom: 2)

        // Then
        XCTAssertEqual(time, "8")
        XCTAssertEqual(amPm, "pm")
    }

    func test_DateEngine_getTimeAndAmpm_givenTimeHasMinutes() {
        // Given
        let tokenizedPhrase = ["today", "at", "8.12", "pm"]

        // When
        let (time, amPm) = dateEngine.getTimeAndAmpm(from: tokenizedPhrase, strartingFrom: 2)

        // Then
        XCTAssertEqual(time, "8.12")
        XCTAssertEqual(amPm, "pm")
    }

    func test_DateEngine_getHour_theCorrectHourIsDetected_am() {
        // Given
        let tokenizedPhrase = ["8", "12"]
        let amPm = "am"

        // When
        let hour = dateEngine.getHour(from: tokenizedPhrase, and: amPm)

        // Then
        XCTAssertEqual(hour, 8)
    }

    func test_DateEngine_getHour_theCorrectHourIsDetected_pm() {
        // Given
        let tokenizedPhrase = ["8", "12"]
        let amPm = "pm"

        // When
        let hour = dateEngine.getHour(from: tokenizedPhrase, and: amPm)

        // Then
        XCTAssertEqual(hour, 20)
    }

    func test_DateEngine_getHour_theCorrectHourIsDetected_noMinutes() {
        // Given
        let tokenizedPhrase = ["8"]
        let amPm = "am"

        // When
        let hour = dateEngine.getHour(from: tokenizedPhrase, and: amPm)

        // Then
        XCTAssertEqual(hour, 8)
    }

    func test_DateEngine_getMinute_theCorrectMinuteIsDetected() {
        // Given
        let tokenizedPhrase = ["8", "12"]

        // When
        let minute = dateEngine.getMinute(from: tokenizedPhrase)

        // Then
        XCTAssertEqual(minute, 12)
    }

    func test_DateEngine_getMinute_theCorrectMinuteIsDetected_noMinuteIsGiven() {
        // Given
        let tokenizedPhrase = ["8"]

        // When
        let minute = dateEngine.getMinute(from: tokenizedPhrase)

        // Then
        XCTAssertEqual(minute, 0)
    }

    func test_DateEngine_getTodaysComponents_todaysComponentsAreGiven() {
        // Given
        let todaysComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date.now)

        // When
        let gettedComponents = dateEngine.getTodaysComponents(increasedBy: "0", of: .days)

        // Then
        XCTAssertEqual(gettedComponents.day, todaysComponents.day)
        XCTAssertEqual(gettedComponents.month, todaysComponents.month)
        XCTAssertEqual(gettedComponents.year, todaysComponents.year)
    }

    func test_DateEngine_getTodaysComponents_tomorrowsComponentsAreGiven() {
        // Given
        let tomorrowsComponents = Calendar.current.dateComponents(
            [.day, .month, .year],
            from: Date.now.increasedBy(days: "1")
        )

        // When
        let gettedComponents = dateEngine.getTodaysComponents(increasedBy: "1", of: .days)

        // Then
        XCTAssertEqual(gettedComponents.day, tomorrowsComponents.day)
        XCTAssertEqual(gettedComponents.month, tomorrowsComponents.month)
        XCTAssertEqual(gettedComponents.year, tomorrowsComponents.year)
    }

    func test_DateEngine_getTodaysComponents_oneYearLaterComponentsAreGiven() {
        // Given
        let nextYearComponents = Calendar.current.dateComponents(
            [.day, .month, .year],
            from: Date.now.increasedBy(days: "365")
        )

        // When
        let gettedComponents = dateEngine.getTodaysComponents(increasedBy: "365", of: .days)

        // Then
        XCTAssertEqual(gettedComponents.day, nextYearComponents.day)
        XCTAssertEqual(gettedComponents.month, nextYearComponents.month)
        XCTAssertEqual(gettedComponents.year, nextYearComponents.year)
    }

    func test_DateEngine_validateReminderSection_allPhrasesAreCorrect() {
        // Given
        let correctPhrases = ["tomorrow at 8 pm",
                              "today at 8 pm",
                              "in 3 days at 8.12 am",
                              "in 3 days at 8.59 pm",
                              "in 1 minute",
                              "in 3 minutes",
                              "in 3 hours"]

        for phrase in correctPhrases {
            // When
            let isPhraseCorrect = dateEngine.validateReminderSection(dateEngine.tokenize(phrase, using: " "))

            // Then
            XCTAssertTrue(isPhraseCorrect)
        }
    }

    func test_DateEngine_validateReminderSection_allPhrasesAreWrong() {
        // Given
        let wrongPhrases = ["tomorro at 8 pm",
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
                            "tomorrow at x"]

        for phrase in wrongPhrases {
            // When
            let isPhraseCorrect = dateEngine.validateReminderSection(dateEngine.tokenize(phrase, using: " "))

            // Then
            XCTAssertFalse(isPhraseCorrect)
        }
    }

    func test_DateEngine_getDateFromString_todayAt8Am() {
        // Given
        let phrase = "Bring out the trash, today at 8 am"
        var givenComponents = dateEngine.getTodaysComponents(increasedBy: "0", of: .days)
        givenComponents.hour = 8
        givenComponents.minute = 0

        // When
        let obtainDate = dateEngine.getDateFromString(phrase)

        // Then
        XCTAssertEqual(obtainDate, Calendar.current.date(from: givenComponents))
    }

    func test_DateEngine_getDateFromString_todayAt8and12Am() {
        // Given
        let phrase = "Bring out the trash, today at 8.12 am"
        var givenComponents = dateEngine.getTodaysComponents(increasedBy: "0", of: .days)
        givenComponents.hour = 8
        givenComponents.minute = 12

        // When
        let obtainDate = dateEngine.getDateFromString(phrase)

        // Then
        XCTAssertEqual(obtainDate, Calendar.current.date(from: givenComponents))
    }

    func test_DateEngine_getDateFromString_tomorrowAt8Am() {
        // Given
        let phrase = "Bring out the trash, tomorrow at 8.12 am"
        var givenComponents = dateEngine.getTodaysComponents(increasedBy: "1", of: .days)
        givenComponents.hour = 8
        givenComponents.minute = 12

        // When
        let obtainDate = dateEngine.getDateFromString(phrase)

        // Then
        XCTAssertEqual(obtainDate, Calendar.current.date(from: givenComponents))
    }

    func test_DateEngine_getDateFromString_in3DaysAt8and12Am() {
        // Given
        let phrase = "Bring out the trash, in 3 days at 8.12 am"
        var givenComponents = dateEngine.getTodaysComponents(increasedBy: "3", of: .days)
        givenComponents.hour = 8
        givenComponents.minute = 12

        // When
        let obtainDate = dateEngine.getDateFromString(phrase)

        // Then
        XCTAssertEqual(obtainDate, Calendar.current.date(from: givenComponents))
    }

    func test_DateEngine_getDateFromString_in3HoursAt8and12Am() {
        // Given
        let phrase = "Bring out the trash, in 3 hours"
        var givenComponents = dateEngine.getTodaysComponents(increasedBy: "3", of: .hours)
        givenComponents.hour = Calendar.current.dateComponents([.hour], from: Date.now.addingTimeInterval(60*60*3)).hour

        // When
        let obtainDate = dateEngine.getDateFromString(phrase)

        // Then
        XCTAssertEqual(obtainDate, Calendar.current.date(from: givenComponents))
    }

    func test_DateEngine_getDateFromString_in3MinutesAt8and12Am() {
        // Given
        let phrase = "Bring out the trash, in 3 minutes"
        var givenComponents = dateEngine.getTodaysComponents(increasedBy: "3", of: .minutes)
        givenComponents.hour = Calendar.current.dateComponents([.hour], from: Date.now.addingTimeInterval(60*3)).hour

        // When
        let obtainDate = dateEngine.getDateFromString(phrase)

        // Then
        XCTAssertEqual(obtainDate, Calendar.current.date(from: givenComponents))
    }

    func test_DateEngine_getReminderSection_() {
        // Given
        let phrase = "Bring out the trash, in 3 days at 8.12 am"

        // When
        let splitPhrase = dateEngine.getReminderSection(for: phrase)

        // Then
        XCTAssertEqual(splitPhrase, "in 3 days at 8.12 am")
    }

    func test_DateEngine_validate_thePhrasesAreValid() {
        // Given
        let correctPhrases = ["Bring out the trash, tomorrow at 8 pm",
                              "Bring out the trash, today at 8 pm",
                              "Bring out the trash, in 3 days at 8.12 am",
                              "Bring out the trash, in 3 days at 8.59 pm" ]

        for phrase in correctPhrases {

            // When
            let isPhraseCorrect = dateEngine.validate(phrase: phrase)

            // Then
            XCTAssertTrue(isPhraseCorrect)
        }
    }

    func test_DateEngine_validate_thePhrasesAreNotValid() {
        // Given
        let wrongPhrases = ["Bring out the trash,tomorrow at 8 pm",
                            "Bring out the trash today at 8 pm"]

        for phrase in wrongPhrases {

            // When
            let isPhraseCorrect = dateEngine.validate(phrase: phrase)

            // Then
            XCTAssertFalse(isPhraseCorrect)
        }
    }

    func test_DateEngine_isRemindalbe_thesePhrasesAreRemindable() {
        // Given
        let correctPhrases = ["Bring out the trash, tomorrow at 8 pm",
                              "Bring out the trash, today at 8 pm",
                              "Bring out the trash, in 3 days at 8.12 am",
                              "Bring out the trash, in 3 days at 8.59 pm",
                              "Bring out the trash, in 3 hours",
                              "Bring out the trash, in 3 minutes"]

        for phrase in correctPhrases {

            // When
            let isPhraseRemindable = dateEngine.isRemindable(phrase)

            // Then
            XCTAssertTrue(isPhraseRemindable)
        }
    }

    func test_DateEngine_isRemindalbe_thesePhrasesAreNotRemindable() {
        // Given
        let correctPhrases = ["Bring out the trash, tomorrow at8 pm",
                              "Bring out the trash, today at 8pm",
                              "Bring out the trash, in 3 days 8.12 am",
                              "Bring out the trash, in 3days at 8.59 pm",
                              "Bring out the trash, in 3 hou",
                              "Bring out the trash, in 3minutes"]

        for phrase in correctPhrases {

            // When
            let isPhraseRemindable = dateEngine.isRemindable(phrase)

            // Then
            XCTAssertFalse(isPhraseRemindable)
        }
    }

    func test_DateEngine_validate_thesePhrasesAreNotValid() {
        // Given
        let wrongPhrases = ["Bring out the trash,tomorrow at 8 pm",
                            "Bring out the trash today at 8 pm"]

        for phrase in wrongPhrases {

            // When
            let isPhraseCorrect = dateEngine.validate(phrase: phrase)

            // Then
            XCTAssertFalse(isPhraseCorrect)
        }
    }

    func test_DateEngine_getNameSection_theSectionContainingTheNameIsGiven() {
        // Given
        let phrase = "Bring out the trash, in 3 days at 8.12 am"

        // When
        let splitPhrase = dateEngine.getNameSection(for: phrase)

        // Then
        XCTAssertEqual(splitPhrase, "Bring out the trash")
    }

    func test_DateEngine_splitInSections_theSectionContainingTheNameIsGiven() {
        // Given
        let phrase = "Bring out the trash, in 3 days at 8.12 am"
        let expectedSplits = ("Bring out the trash", "in 3 days at 8.12 am")

        // When
        let (nameSection, reminderSection) = dateEngine.splitInSections(phrase)

        // Then
        XCTAssertEqual(expectedSplits.0, nameSection)
        XCTAssertEqual(expectedSplits.1, reminderSection)
    }

}
