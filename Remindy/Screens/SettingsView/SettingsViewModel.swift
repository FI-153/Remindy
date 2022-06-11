//
//  SettingsViewModel.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 13/05/22.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var item = Item(context: PersistanceManager.getShared().childContext)
    @Binding var isSettingViewOpened: Bool
    let persistanceManager = PersistanceManager.getShared()

    init(isSettingViewOpened: Binding<Bool>) {
        self._isSettingViewOpened = isSettingViewOpened

        item.name = "Pet the dog, today at 8 pm"
        item.isRemindable = true
        item.isReminded = true
    }
}

