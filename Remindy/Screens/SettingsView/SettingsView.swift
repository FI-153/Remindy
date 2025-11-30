//
//  SettingsView.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 05/05/22.
//

import SwiftUI

struct SettingsView: View {

    @StateObject var vm: SettingsViewModel
    @EnvironmentObject var colorManager: ColorManager

    init(isSettingViewOpened: Binding<Bool>) {
        _vm = .init(wrappedValue: SettingsViewModel(isSettingViewOpened: isSettingViewOpened))
    }

    var body: some View {
        VStack(spacing: 20) {

            sampleReminderSection
            
            dividerView
            
            HStack(spacing: 30) {
                circleColorSection
                reminderColorSection
            }

            dividerView
            
            HStack {
                resetColorSection
                clearReminderSection
            }
            .buttonStyle(.plain)

        }
        .frame(minWidth: 450, minHeight: 350)
        .background(Material.ultraThin)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(alignment: .topTrailing) {
            xCrossButton
        }
    }

}

struct SettingsViewButtonModifiers: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 150, height: 30)
            .background(Color.red.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))

    }
}

extension SettingsView {
    private var sampleReminderSection: some View {
        ZStack{
            VStack {
                CellView(item: vm.sampleItem)
            }
            
            //Used to disable the textfiled without changing its colors with .disabled(true)
            Rectangle().fill(Color.primary.opacity(0.001))
        }
        .frame(width: 400, height: 40)
    }

    private var circleColorSection: some View {

        VStack(spacing: 10) {
            Text("Circle Color")
                .font(.title2)

            HStack {
                ForEach(colorManager.availableCircleColor, id: \.self) { color in
                    Button {
                        colorManager.setCircleColor(to: color)
                    } label: {
                        Image(systemName: color == colorManager.circleColor 
                              ? "largecircle.fill.circle"
                              : "circle.fill")
                            .foregroundColor(color)
                    }
                }
                .font(.title)
            }
            .buttonStyle(.plain)
        }
    }

    private var reminderColorSection: some View {
        VStack(spacing: 10) {
            Text("Reminder Color")
                .font(.title2)

            HStack {

                ForEach(colorManager.availableReminderColor, id: \.self) {color in
                    Button {
                        colorManager.setReminderColor(to: color)
                    } label: {
                        Image(systemName: color == colorManager.reminderColor
                              ?"largecircle.fill.circle"
                              : "circle.fill")
                            .foregroundColor(color)
                    }
                }
                .font(.title)
            }
            .buttonStyle(.plain)
        }
    }

    private var resetColorSection: some View {
        Button {
            colorManager.resetColors()
        } label: {
            ZStack {
                Text("Reset Colors")
                    .font(.title3)
            }
            .modifier(SettingsViewButtonModifiers())
        }
    }

    private var clearReminderSection: some View {
        Button {
            vm.persistanceManager.deleteAllSavedItems()
        } label: {
            ZStack {
                Text("Clear Reminders")
                    .font(.title3)
            }
            .modifier(SettingsViewButtonModifiers())
        }
    }

    private var xCrossButton: some View {
        Button {
            vm.isSettingViewOpened = false
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .opacity(0.6)
                .padding()
        }
        .buttonStyle(.plain)
    }
    
    private var dividerView: some View{
        Divider()
            .frame(width: 400)
    }

}

#Preview("Settings View"){
    SettingsView(isSettingViewOpened: .constant(false))
        .frame(minWidth: 500, idealWidth: 500, minHeight: 400)
        .environmentObject(ColorManager())
}
