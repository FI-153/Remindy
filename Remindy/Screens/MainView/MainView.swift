//
//  ContentView.swift
//  MinimalReminderApp
//
//  Created by Federico Imberti on 26/04/22.
//

import SwiftUI
import CoreData

struct MainView: View {

    @StateObject var vm = MainViewModel()

    let notificationManager = NotificationManager.getShared()
    @State var isSettingViewOpened: Bool = false

    @EnvironmentObject var colorManager: ColorManager

    var body: some View {

        ZStack {
            VStack(alignment: .leading) {

                inputSection

                Divider()

                scrollViewSection

                Spacer()

                HStack {
                    quitButton
                    Spacer()
                    settingsButton
                }
                .background(colorManager.reminderColor.opacity(0.1))

            }
            .blur(radius: isSettingViewOpened ? 3 : 0)
            .disabled(isSettingViewOpened)

            SettingsView(isSettingViewOpened: $isSettingViewOpened)
                .animation(.spring(), value: isSettingViewOpened)
                .offset(y: isSettingViewOpened ? 0 : 500)
        }

    }
}

extension MainView {
    private var inputSection: some View {
        TextField("Type something to remember...", text: $vm.newItemName)
            .textFieldStyle(.plain)
            .onSubmit {
                vm.addItem(named: vm.newItemName)
                vm.clerTypedText()
            }
            .font(.largeTitle)
            .padding()
            .padding(.top, 10)
    }

    private var scrollViewSection: some View {
        ScrollView {
            ForEach(vm.fetchedItems) { item in
                CellView(item: item)
                    .animation(.easeOut(duration: 0.3), value: vm.fetchedItems)
            }
        }
    }
    
    private var quitButton: some View{
        Button {
            exit(0)
        } label: {
            Label {
                Text("Quit app")
                    .font(.system(size: 12, weight: .semibold))
            } icon: {
                Image(systemName: "power")
                    .font(.system(size: 12, weight: .bold))
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
    
    private var settingsButton: some View{
        Button {
            isSettingViewOpened = true
        } label: {
            Image(systemName: "gear")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
        .buttonStyle(.plain)
        .padding()
    }
}

#if DEBUG
struct ContentView_Previews_dark: PreviewProvider {
    static var previews: some View {
        MainView(isSettingViewOpened: false)
            .preferredColorScheme(.dark)
            .environmentObject(ColorManager())
    }
}

struct ContentView_Previews_light: PreviewProvider {
    static var previews: some View {
        MainView(isSettingViewOpened: false)
            .preferredColorScheme(.light)
            .environmentObject(ColorManager())
    }
}

#endif
