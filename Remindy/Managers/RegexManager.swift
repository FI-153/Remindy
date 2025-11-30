//
//  RegexManager.swift
//  Remindy
//
//  Created by Federico Imberti on 11/06/22.
//

import Foundation

class RegexManager {
    
    enum PossibleRegexes{
        case inTodayTomorrow, inNDays, inNMinutes, inNHours
    }
    
    let regexes: [PossibleRegexes: String] = [
        // Matches "today/tomorrow", optional minutes (e.g. 5.30 or just 5), optional space before am/pm
        .inTodayTomorrow: "(today|tomorrow) at (1[0-2]|0?[1-9])((.|:)[0-5][0-9])? ?(am|pm)",
        
        // Matches "in 1 day" or "in 12 days", same time logic as above
        .inNDays: "in [1-9][0-9]? days? at (1[0-2]|0?[1-9])((.|:)[0-5][0-9])? ?(am|pm)",
        
        // Matches "in 5 minutes", "in 120 minutes" (1-3 digits)
        .inNMinutes: "in [1-9][0-9]{0,2} minutes?",
        
        // Matches "in 1 hour", "in 12 hours"
        .inNHours: "in [1-9][0-9]{0,2} hours?"
    ]
    
    let options:NSRegularExpression.Options = [.caseInsensitive]
    
    ///           Format of a valid string
    ///    _________________________________________
    ///     today          |         |           |
    ///                  |           |   n           |  am
    ///     tomorrow    |   at   |           |
    ///                  |           |   n.ab      |  pm
    ///     in n days    |          |           |
    ///    -----------------------------------------
    ///                  |           |  minutes  |
    ///     in                |   n    |           |
    ///                  |           |  hours      |
    ///    -----------------------------------------
    func validateReminderSection(_ string: String) -> Bool {
        
        for regex in regexes {
            let range = NSRange(location: 0, length: string.utf16.count)
            let regex = try! NSRegularExpression(pattern: regex.value, options: options)
            if regex.firstMatch(in: string, range: range) != nil {
                return true
            }
        }
        
        return false
    }

}
