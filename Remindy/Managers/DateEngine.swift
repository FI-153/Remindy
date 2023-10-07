//
//  DateEngine.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 27/04/22.
//

import Foundation

class DateEngine {
    
    let regexManager = RegexManager()

    /**
     - Returns: the tokenized phrase as an arrays of its String components lowercased
     */
    func tokenize(_ phrase: String, using separator: String) -> [String] {
        phrase.components(separatedBy: separator).map({$0.lowercased()})
    }

    /// Finds the index of the word with a comma
    /// - Returns: The index of the first word suffixed with a comma if found
    func findIndexOfWordWithComma(of tokenizedPhrase: [String]) -> Int? {

        var index: Int?
        
        for currentIndex in tokenizedPhrase.indices {
            if tokenizedPhrase[currentIndex].hasSuffix(",") {
                index = currentIndex
                break
            }
        }
        
        return index
    }
    /// - Returns: The value related to the time int the tokenized phrase and if it is Am or Pm
    func getTimeAndAmpm(from tokenizedPhrase: [String], strartingFrom index: Int) -> (time:String, amPm:String) {
        return (tokenizedPhrase[index], tokenizedPhrase[index+1])
    }

    /// - Returns: The time adjusted in a 24h format
    func getHour(from tokenizedTime: [String], and amPm: String) -> Int {

        var adjustedTime = 0

        if
            let hour = tokenizedTime.first,
            let baseTime = Int(hour) 
        {
            adjustedTime =  baseTime + (amPm.lowercased() == "pm" ? 12 : 0)
        }

        return adjustedTime
    }

    /// - Returns: The minutes in the tkenized string, if present
    func getMinute(from tokenizedTime: [String]) -> Int {
        if
            tokenizedTime.count == 2,
            let minute = Int(tokenizedTime[1])
        {
            return minute
        }
            
        return 0
    }

    /// - Returns: Day, Month, Year, Hour and Minute of today, increased by the given amount
    func getTodaysComponents(increasedBy units: String, of option: increasingOptions) -> DateComponents {
        let components:Set<Calendar.Component> = [.day, .month, .year, .hour, .minute]
        
        switch option {
        case .days:
            return Calendar
                .current
                .dateComponents(components, from: Date.now.increasedBy(days: units))
        case .minutes:
            return Calendar
                .current
                .dateComponents(components, from: Date.now.increasedBy(minutes: units))
        case .hours:
            return  Calendar
                .current
                .dateComponents(components, from: Date.now.increasedBy(hours: units))
        }
    }

    /// Validates a phrase
    /// - Returns: True if the string contains a comma
    func validate(_ phrase: String) -> Bool {
        phrase.contains(", ")
    }

    /// - Returns: the reminder section, which is the one after the comma
    func getReminderSection(for phrase: String) -> String {

        let splittedPhrase = phrase.split(separator: ",")
        var interestedPart = String(splittedPhrase[1])

        // removes the first space after the comma
        if
            let index = interestedPart.firstIndex(of: " ")
        {
            interestedPart.remove(at: index)
        }

        return interestedPart
    }

    /// - Returns: The name section, which is the one before the comma
    func getNameSection(for phrase: String) -> String {
        let splittedPhrase = phrase.split(separator: ",")
        return String(splittedPhrase[0])
    }

    /// Splits the given phrase in the name and remidner sections
    /// - Returns: The left side of the comma as `name` and the right side as `reminder`
    func splitInSections(_ phrase: String) -> (name: String, reminder: String) {
        return (getNameSection(for: phrase), getReminderSection(for: phrase))
    }
        
    func isAmPmValid(for string: String) -> Bool {
        string == "pm" || string == "am"
    }

    /// - Returns: True if the hour is within 0 and 12 and the minutes are between 0 and 59
    func isWithinTimeBoundairesForTwoDigits(_ twoDigitsTokenizedTime: [String]) -> Bool {
        Int(twoDigitsTokenizedTime[0]) ?? -1 >= 0 &&
        Int(twoDigitsTokenizedTime[0]) ?? 13 <= 12 &&
        Int(twoDigitsTokenizedTime[1]) ?? 60 <= 59 &&
        Int(twoDigitsTokenizedTime[1]) ?? -1 >= 0
    }
    
    /// - Returns: True if the hour is within 0 and 12
    func isWithinTimeBoundairesForOneDigit(_ oneDigitTokenizedTime: [String]) -> Bool {
        Int(oneDigitTokenizedTime[0]) ?? -1 >= 0 && Int(oneDigitTokenizedTime[0]) ?? 13 <= 12
    }

    /// - Returns: True if the array has 2 values, meaning if the user gave both hours and minutes
    func tokenizedTimeHasTwoDigits(_ tokenizedTime: [String]) -> Bool {
        tokenizedTime.count == 2
    }

    /// Determines if a phrase is remindable
    /// - Returns: True if the phrase is remindable, otherwise false
    func isRemindable(_ phrase: String) -> Bool {
        return validate(phrase) && regexManager.validateReminderSection(phrase)
    }

    /// Validates the time
    /// - Returns: True if the given time is present and formatted correctly, for example 12.34 AM or 12 PM
    func isTimeValid(for tokenizedPhrase: [String], statringFrom index: Int) -> Bool {
        let tokenizedTime = tokenize(tokenizedPhrase[index], using: ".")

        guard isAmPmValid(for: tokenizedPhrase[index+1]) else { return false }

        if tokenizedTimeHasTwoDigits(tokenizedTime) {
            guard isWithinTimeBoundairesForTwoDigits(tokenizedTime) else { return false }
            return true
        } else {
            guard isWithinTimeBoundairesForOneDigit(tokenizedTime) else { return false }
            return true
        }
    }

    /// - Returns: True if the number of days is grater of equal to 0, otherwise false
    func isValidNumberOfDays(_ string: String) -> Bool {
        return (Int(string) ?? -1) >= 0
    }

    /// Given a remindable string it produces a Date from it, when possible
    /// - Returns: The parsed string to a Date? object otherwise a nil
    func getDateFromString(_ phrase: String) -> Date? {

        let tokenizedPhrase = tokenize(phrase, using: " ")
        let firstIndex = findIndexOfWordWithComma(of: tokenizedPhrase)

        guard let firstIndex = firstIndex else {
            //The phrase is not remindable
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
    
    /// Gives the possible units of measurement o increase the date
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
