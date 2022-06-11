//
//  RemindyApp.swift
//  Remindy
//
//  Created by Federico Imberti on 11/06/22.
//

import SwiftUI
import Combine

@main
struct RemindyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings {
            AnyView(_fromValue: delegate)
                .background(Material.ultraThick)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    var popOver = NSPopover()

    func applicationDidFinishLaunching(_ notification: Notification) {
        setUpMacButton()
    }

    func setUpMacButton() {
        popOverProperties()
        linkToSwiftUI()
        popOver.contentViewController?.view.window?.makeKey()
        setUpStatusItem()
    }

    func popOverProperties() {
        popOver.animates = true
        popOver.behavior = .transient
        popOver.contentSize = NSSize(width: 600, height: 500)
    }

    func linkToSwiftUI() {
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: MainView().environmentObject(ColorManager()))
    }

    func setUpStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "bell.fill", accessibilityDescription: "Simple Reminder App")
            menuButton.action = #selector(menuButtonAction(sender:))
        }
    }

    /// Shows or dismisses the popup screen
    @objc func menuButtonAction(sender: AnyObject) {
        if popOver.isShown {
            popOver.performClose(sender)
        } else {
            if let menuButton = statusItem?.button {
                popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
                self.popOver.contentViewController?.view.window?.becomeKey()
            }
        }
    }
}
