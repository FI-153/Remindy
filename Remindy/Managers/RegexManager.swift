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
    
    let regexes:[PossibleRegexes:String] = [
        .inTodayTomorrow : "[todaytomorrow] at [0-9]{0,1}[0-2]{0,1}.{0,1}[0-5]{0,1}[0-9]{0,1}[ ][ampm]",
        .inNDays : "in [1-9]{1,2} day[s]* at [0-9]{0,1}[0-2]{0,1}.{0,1}[0-5]{0,1}[0-9]{0,1}[ ][ampm]",
        .inNMinutes : "in [1-9]{1,3} minute[s]*",
        .inNHours : "in [1-9]{1,3} hour[s]*"
    ]
    
    let options:NSRegularExpression.Options = [.caseInsensitive]
    
    ///           Format of a valid string
    ///    _________________________________________
    ///     today       |        |           |
    ///                 |        |   n       |  am
    ///     tomorrow    |   at   |           |
    ///                 |        |   n.ab    |  pm
    ///     in n days   |        |           |
    ///    -----------------------------------------
    ///                 |        |  minutes  |
    ///     in          |   n    |           |
    ///                 |        |  hours    |
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
