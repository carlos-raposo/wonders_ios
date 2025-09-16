//
//  WondersApp.swift
//  Wonders
//
//  Created by Carlos Raposo on 03/09/2025.
//

import SwiftUI
import Firebase

@main
struct WondersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        FirebaseApp.configure()
    }
    var languageSettings = LanguageSettings()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageSettings)
        }
    }
}
