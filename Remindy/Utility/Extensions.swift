//
//  Extensions.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 26/04/22.
//

import SwiftUI

extension String {
    static let empty = ""
    
    func uppercaseFirstLetter() -> String {
        guard let firstLetter = self.first else { return self }
        
        let firstLetterUppercsed: String = String(firstLetter).uppercased()
        let otherPartOfTheWord: String = String(self.dropFirst())
        return firstLetterUppercsed.appending(otherPartOfTheWord)
    }
}

extension View {

    func renderAsImage() -> NSImage? {
        let view = NoInsetHostingView(rootView: self)
        view.setFrameSize(view.fittingSize)
        return view.bitmapImage()
    }

}

class NoInsetHostingView<V>: NSHostingView<V> where V: View {

    override var safeAreaInsets: NSEdgeInsets {
        return .init()
    }

}

public extension NSView {

    func bitmapImage() -> NSImage? {
        guard let rep = bitmapImageRepForCachingDisplay(in: bounds) else {  return nil }
        
        cacheDisplay(in: bounds, to: rep)
        guard let cgImage = rep.cgImage else { return nil }
        
        return NSImage(cgImage: cgImage, size: bounds.size)
    }

}

extension Date {
    func increasedBy(days: String) -> Date {
        guard let daysAsNumbers = Int(days) else { return self }
        return self.addingTimeInterval(Double(86400 * daysAsNumbers))
        
    }

    func increasedBy(minutes: String) -> Date {
        guard let minutesAsNumer = Int(minutes) else { return self }
        return self.addingTimeInterval(Double(60 * minutesAsNumer))
    }

    func increasedBy(hours: String) -> Date {
        guard let hoursAsNumber = Int(hours) else { return self }
        return self.addingTimeInterval(Double(3600 * hoursAsNumber))
    }
}

extension Color {
    func toRGB() -> [Float] {
        
        let nsColor = NSColor(self)
        guard let ciColor: CIColor = CIColor(color: nsColor) else { return [] }
        return [ciColor.red, ciColor.green, ciColor.blue].map {Float($0)}
    }

    func saveToUserDefaults(named name: String) {
        let colorComponents = self.toRGB()

        UserDefaults.standard.set(colorComponents[0], forKey: name.appending("-R"))
        UserDefaults.standard.set(colorComponents[1], forKey: name.appending("-G"))
        UserDefaults.standard.set(colorComponents[2], forKey: name.appending("-B"))
    }

    static func getFromMemory(named name: String) -> Color? {
        let red = Double(UserDefaults.standard.float(forKey: name.appending("-R")))
        let green = Double(UserDefaults.standard.float(forKey: name.appending("-G")))
        let blue = Double(UserDefaults.standard.float(forKey: name.appending("-B")))

        if red.isEqual(to: 0) && green.isEqual(to: 0) && blue.isEqual(to: 0) {
            return nil
        } else {
            return Color(red: red, green: green, blue: blue, opacity: 1)
        }
    }

}
