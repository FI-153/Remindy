//
//  CellView.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 26/04/22.
//

import SwiftUI

struct CellView: View {

    var item: Item

    private let dateEngine = DateEngine()
    private let persistanceManager = PersistanceManager.getShared()
    private let notificationManager = NotificationManager.getShared()

    @EnvironmentObject var colorManager: ColorManager

    var body: some View {
        HStack(spacing: 20) {
            circleSection

            if let name = item.name {
                Group {
                    if item.isRemindable {
                        composeText(for: name)
                    } else {
                        Text(name)
                    }
                }
                .font(.title2)
            }

            Spacer()

            bellButtonSection

        }
        .padding(.horizontal, 20)
        .frame(height: 40)
    }
}

extension CellView {
    private var circleSection: some View {
        Button {
            persistanceManager.delete(item)

            if item.isReminded {
                notificationManager.removeNotification(for: item)
            }
        } label: {
            Image(systemName: "circle")
                .font(.title2)
                .foregroundColor(colorManager.circleColor)
        }
        .buttonStyle(.plain)
    }

    private func composeText(for phrase: String) -> some View {
        let (nameSection, reminderSection) = dateEngine.splitInSections(phrase)

        return HStack(spacing: 0) {
            Text(nameSection)

            Text(", ")

            Text(reminderSection)
                .fontWeight(item.isReminded ? .medium : .regular)
                .foregroundColor(item.isReminded ? colorManager.reminderColor : .primary)
        }
    }

    private var bellButtonSection: some View {
        Button {

            if item.isReminded {
                notificationManager.removeNotification(for: item)
            } else if
                let name = item.name,
                let date = dateEngine.getDateFromString(name) {
                notificationManager.addCalendarNotification(for: item, at: date)
            }

            persistanceManager.toggleIsReminded(for: item)
        } label: {
            if item.isRemindable {
                Image(systemName: item.isReminded ? "bell.fill" : "bell" )
                    .resizable()
                    .foregroundColor(item.isReminded ? colorManager.reminderColor : .primary)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 5)
    }
}

#Preview("Normal Reminder") {
    let item = Item(context: PersistanceManager.getShared().containerContext)
    item.name = "Reminder title"
    
    return CellView(item: item)
        .environmentObject(ColorManager())
}

#Preview("Remindable Reminder"){
    let item = Item(context: PersistanceManager.getShared().containerContext)
    item.name = "Reminder title, at 12 am"
    item.isRemindable = true
    
    return CellView(item: item)
        .environmentObject(ColorManager())
}

#Preview("Normal Reminder with Notification"){
    let item = Item(context: PersistanceManager.getShared().containerContext)
    item.name = "Reminder title, at 12 am"
    item.isRemindable = true
    item.isReminded = true
    
    return CellView(item: item)
        .environmentObject(ColorManager())
}
