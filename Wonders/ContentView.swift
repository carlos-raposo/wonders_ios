//
//  ContentView.swift
//  Wonders
//
//  Created by Carlos Raposo on 03/09/2025.
//

import SwiftUI

// MARK: - Theme Colors
struct WondersTheme {
    static let lightBackground = Color(hex: "#FFFFFF")
    static let darkBackground = Color(hex: "#09080B")
    static let lightText = Color(hex: "#141218")
    static let darkText = Color(hex: "#FFF8F0")
    static let buttonBlue = Color.blue
    static let buttonDarkBlue = Color.blue // Customize as needed
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isUserLoggedIn") private var isAuthenticated = false
    @AppStorage("isDarkMode") private var isDarkMode = false // Persist dark mode
    @State private var showLogin = false
    @State private var showSignup = false
    @State private var showForgotPassword = false
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var languageSettings = LanguageSettings()
    @State private var selectedTab: Int = 0
    @State private var showLaunchAnimation: Bool = true

    var body: some View {
        NavigationStack {
            MainTabView(
                selectedTab: $selectedTab,
                showLogin: $showLogin,
                onAuthenticated: {
                    isAuthenticated = true
                    favoritesManager.refreshFavorites()
                }
            )
            .environmentObject(favoritesManager)
            .environmentObject(languageSettings)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .fullScreenCover(isPresented: $showLaunchAnimation) {
            LaunchAnimationView(isPresented: $showLaunchAnimation)
                .environmentObject(languageSettings)
        }
        .sheet(isPresented: $showLogin) {
            LoginView(onAuthenticated: {
                isAuthenticated = true
                favoritesManager.refreshFavorites()
                showLogin = false
            })
            .environmentObject(languageSettings)
        }
    }
}

// MARK: - Authentication Flow
struct AuthenticationFlowView: View {
    @Binding var showLogin: Bool
    @Binding var showSignup: Bool
    @Binding var showForgotPassword: Bool
    var onAuthenticated: () -> Void
    @EnvironmentObject var languageSettings: LanguageSettings

    var body: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 16)

            // Lottie Animation Placeholder
            LottieView(filename: "welcome_animation")
                .frame(height: 290)
                .shadow(radius: 1)

            Spacer(minLength: 16)

            VStack(spacing: 16) {
                Button(action: { showLogin = true }) {
                    Text(languageSettings.language == "pt" ? "Entrar" : "Sign In")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(WondersTheme.buttonBlue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 2)
                }
                Button(action: { showSignup = true }) {
                    Text(languageSettings.language == "pt" ? "Criar Conta" : "Sign Up")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(WondersTheme.buttonBlue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 2)
                }
                Button(action: { showForgotPassword = true }) {
                    Text(languageSettings.language == "pt" ? "Esqueceu a senha" : "Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(WondersTheme.buttonBlue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .padding()
    }
}

// MARK: - Authentication Screens (Custom UI)
// (ForgotPasswordView, InstructionsView are now in their own files)

#Preview {
    ContentView()
}
