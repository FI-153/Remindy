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

    init() {
        reminderColor = Color.getFromMemory(named: "reminderColor") ?? .yellow
        circleColor = Color.getFromMemory(named: "circleColor") ?? .primary
    }

    func resetColors() {
        reminderColor = .yellow
        circleColor = .primary
    }

    func setReminderColor(to color: Color) {
        reminderColor = color
    }

    func setCircleColor(to color: Color) {
        circleColor = color
    }

}
