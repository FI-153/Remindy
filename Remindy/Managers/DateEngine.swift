//
//  DateEngine.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 27/04/22.
//

import Foundation

class DateEngine {

    /// Tokenizes a phrase using a given separator
    func tokenize(_ phrase: String, using separator: String) -> [String] {
        phrase.components(separatedBy: separator).map({$0.lowercased()})
    }

    /// Finds the first word with a comma
    func findWordWithComma(in tokenizedPhrase: [String]) -> String? {
        tokenizedPhrase.first(where: { string in
            string.hasSuffix(",")
        })
    }

    /// Gives the index of the word with a comma
    func findIndexOfWordWithComma(of tokenizedPhrase: [String]) -> Int? {

        var index: Int?
        let mainToken = findWordWithComma(in: tokenizedPhrase)

        for currentIndex in tokenizedPhrase.indices {
            if tokenizedPhrase[currentIndex] == mainToken {

                index = currentIndex
                break
            }
        }

        return index
    }

    func getTimeAndAmpm(from tokenizedPhrase: [String], strartingFrom index: Int) -> (String, String) {
        let time = tokenizedPhrase[index]
        let amPm = tokenizedPhrase[index+1]

        return (time, amPm)
    }

    func getHour(from tokenizedTime: [String], and amPm: String) -> Int {

        var adjustedTime = 0

        if
            let firstItem = tokenizedTime.first,
            let baseTime = Int(firstItem) {

            adjustedTime =  baseTime + ( amPm.lowercased() == "pm" ? 12 : 0)
        }

        return adjustedTime
    }

    func getMinute(from tokenizedTime: [String]) -> Int {
        if
            tokenizedTime.count == 2,
            let minute = Int(tokenizedTime[1]) {

            return minute
        } else {
            return 0
        }
    }

    /// Gets day, month and year of today
    func getTodaysComponents(increasedBy units: String, of option: increasingOptions) -> DateComponents {
        switch option {
        case .days:
            return Calendar.current
                .dateComponents([.day, .month, .year, .hour, .minute],
                                from: Date.now.increasedBy(days: units)
                )
        case .minutes:
            return Calendar.current
                .dateComponents([.day, .month, .year, .hour, .minute],
                                from: Date.now.increasedBy(minutes: units)
                )
        case .hours:
            return  Calendar.current
                .dateComponents([.day, .month, .year, .hour, .minute],
                                from: Date.now.increasedBy(hours: units)
                )
        }
    }

    /// Validates a phrase
    func validate(phrase: String) -> Bool {
        phrase.contains(", ")
    }

    /// Gets the reminder section, which is the one after the comma
    func getReminderSection(for phrase: String) -> String {

        let splittedPhrase = phrase.split(separator: ",")
        var interestedPart = String(splittedPhrase[1])

        // removes the first space
        if let index = interestedPart.firstIndex(of: " ") {
            interestedPart.remove(at: index)
        }

        return interestedPart
    }

    /// Gets the name section, which is the one before the comma
    func getNameSection(for phrase: String) -> String {
        let splittedPhrase = phrase.split(separator: ",")
        return String(splittedPhrase[0])
    }

    /// Splits the given phrase in the name and remidner sections
    func splitInSections(_ phrase: String) -> (String, String) {
        let nameSection = getNameSection(for: phrase)
        let reminderSection = getReminderSection(for: phrase)

        return (nameSection, reminderSection)
    }

    ///          Format of a valid string
    ///    ________________________________________
    ///     today       |       |           |
    ///                 |       |     n     |   am
    ///     tomorrow    |   at  |           |
    ///                 |       |   n.ab    |   pm
    ///     in n days   |       |           |
    ///    ----------------------------------------
    ///                 |       |  minutes
    ///         in      |   n   |
    ///                 |       |   hours
    func validateReminderSection(_ tokenizedPhrase: [String]) -> Bool {

        let numOfWords = tokenizedPhrase.count

        switch tokenizedPhrase[0] {

        case "in":

            guard numOfWords > 1 else { return false }
            guard isValidNumberOfDays(tokenizedPhrase[1]) else { return false }

            if numOfWords == 6 && (tokenizedPhrase[2] == "day" || tokenizedPhrase[2] == "days") {

                guard tokenizedPhrase[3] == "at" else { return false }

                return isTimeValid(for: tokenizedPhrase, statringFrom: 4)

            } else if numOfWords == 3 && (tokenizedPhrase[2] == "minute" ||
                                          tokenizedPhrase[2] == "minutes" ||
                                          tokenizedPhrase[2] == "hour" ||
                                          tokenizedPhrase[2] == "hours") {

                return true
            }

        case "today", "tomorrow":

            guard numOfWords == 4 else { return false }
            guard tokenizedPhrase[1] == "at" else { return false }

            return isTimeValid(for: tokenizedPhrase, statringFrom: 2)

        default: return false
        }

        return false
    }

    func isAmPmValid(for string: String) -> Bool {
        string == "pm" || string == "am"
    }

    func isWithinTimeBoundairesForTwoDigits(_ twoDigitsTokenizedTime: [String]) -> Bool {
        Int(twoDigitsTokenizedTime[0]) ?? -1 >= 0 &&
        Int(twoDigitsTokenizedTime[0]) ?? 13 <= 12 &&
        Int(twoDigitsTokenizedTime[1]) ?? 60 <= 59 &&
        Int(twoDigitsTokenizedTime[1]) ?? -1 >= 0
    }

    func isWithinTimeBoundairesForOneDigit(_ oneDigitTokenizedTime: [String]) -> Bool {
        Int(oneDigitTokenizedTime[0]) ?? -1 >= 0 && Int(oneDigitTokenizedTime[0]) ?? 13 <= 12
    }

    func tokenizedTimeHasTwoDigits(_ tokenizedTime: [String]) -> Bool {
        tokenizedTime.count == 2
    }

    /// Determines if a phrase is remindable
    func isRemindable(_ phrase: String) -> Bool {
        validate(phrase: phrase) && validateReminderSection(tokenize(getReminderSection(for: phrase), using: " "))
    }

    /// Validates the time, for example 12.34 AM or 12 PM
    func isTimeValid(for tokenizedPhrase: [String], statringFrom index: Int) -> Bool {
        let tokenizedTime = tokenize(tokenizedPhrase[index], using: ".")

        if tokenizedTimeHasTwoDigits(tokenizedTime) {

            guard isWithinTimeBoundairesForTwoDigits(tokenizedTime) else { return false }
            guard isAmPmValid(for: tokenizedPhrase[index+1]) else { return false }
            return true

        } else {

            guard isWithinTimeBoundairesForOneDigit(tokenizedTime) else { return false }
            guard isAmPmValid(for: tokenizedPhrase[index+1]) else { return false }
            return true

        }
    }

    func isValidNumberOfDays(_ string: String) -> Bool {
        return (Int(string) ?? -1) >= 0
    }

    /// Given a remindable string it produces a Date? from it
    func getDateFromString(_ phrase: String) -> Date? {

        let tokenizedPhrase = tokenize(phrase, using: " ")
        let firstIndex = findIndexOfWordWithComma(of: tokenizedPhrase)

        guard let firstIndex = firstIndex else {
            return nil
        }

        var timeAmPmIndex: Int
        var auxiliaryComponentsIncrease: String

        switch tokenizedPhrase[firstIndex+1] {
        case "tomorrow":

            timeAmPmIndex = firstIndex + 3
            auxiliaryComponentsIncrease = "1"

        case "today":

            timeAmPmIndex = firstIndex + 3
            auxiliaryComponentsIncrease = "0"

        case "in":

            timeAmPmIndex = firstIndex + 5
            auxiliaryComponentsIncrease = tokenizedPhrase[firstIndex+2]

            // Handles "in n hours" and "in n minutes"
            if tokenizedPhrase[firstIndex+3] == "hours" || tokenizedPhrase[firstIndex+3] == "hour" {

                let components = getTodaysComponents(increasedBy: auxiliaryComponentsIncrease, of: .hours)
                return Calendar.current.date(from: components)

            } else if tokenizedPhrase[firstIndex+3] == "minutes" || tokenizedPhrase[firstIndex+3] == "minute" {

                let components = getTodaysComponents(increasedBy: auxiliaryComponentsIncrease, of: .minutes)
                return Calendar.current.date(from: components)
            }

        default: return nil
        }

        let (time, amPm) = getTimeAndAmpm(from: tokenizedPhrase, strartingFrom: timeAmPmIndex)
        let tokenizedTime = tokenize(time, using: ".")

        var components = DateComponents()
        components.hour = getHour(from: tokenizedTime, and: amPm)
        components.minute = getMinute(from: tokenizedTime)

        let auxiliaryComponents = getTodaysComponents(increasedBy: auxiliaryComponentsIncrease, of: .days)
        components.day = auxiliaryComponents.day
        components.month = auxiliaryComponents.month
        components.year = auxiliaryComponents.year

        return Calendar.current.date(from: components)
    }

    enum increasingOptions: CustomStringConvertible {
        case days, minutes, hours

        var description: String {
            switch self {
            case .days:
                return "days"
            case .minutes:
                return "minutes"
            case .hours:
                return "hours"
            }
        }

    }

}
