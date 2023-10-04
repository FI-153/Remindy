//
//  ColorManager.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 05/05/22.
//

import SwiftUI

class ColorManager: ObservableObject {
    @Published var reminderColor: Color {
        didSet {
            reminderColor.saveToUserDefaults(named: "reminderColor")
        }
    }
    @Published var circleColor: Color {
        didSet {
            circleColor.saveToUserDefaults(named: "circleColor")
        }
    }

    let availableReminderColor: [Color] = [.yellow, .green, .cyan, .accentColor]
    let availableCircleColor: [Color] = [.primary, .teal.opacity(0.8), .brown, .gray]

    let defaultReminderColor:Color = .yellow
    let defaultCircleColor:Color = .primary
    init() {
        reminderColor = Color.getFromMemory(named: "reminderColor") ?? defaultReminderColor
        circleColor = Color.getFromMemory(named: "circleColor") ?? defaultCircleColor
    }

    func resetColors() {
        reminderColor = defaultReminderColor
        circleColor = defaultCircleColor
    }

    func setReminderColor(to color: Color) {
        reminderColor = color
    }

    func setCircleColor(to color: Color) {
        circleColor = color
    }

}
