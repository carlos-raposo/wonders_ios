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
    
    // Instâncias Globais dos Serviços
    @StateObject private var languageSettings = LanguageSettings()
    @StateObject private var purchaseManager = PurchaseManager.shared // 👈 Injeta o PurchaseManager com StoreKit 2
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageSettings)
                .environmentObject(purchaseManager) // 👈 Fica disponível para toda a hierarquia da app
        }
    }
}
