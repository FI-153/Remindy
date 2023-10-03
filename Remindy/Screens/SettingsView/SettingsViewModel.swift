//
//  SettingsViewModel.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 13/05/22.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var sampleItem = Item(context: PersistanceManager.getShared().childContext)
    @Binding var isSettingViewOpened: Bool
    let persistanceManager = PersistanceManager.getShared()

    init(isSettingViewOpened: Binding<Bool>) {
        self._isSettingViewOpened = isSettingViewOpened

        sampleItem.name = "Pet the dog, today at 8 pm"
        sampleItem.isRemindable = true
        sampleItem.isReminded = true
    }
}

