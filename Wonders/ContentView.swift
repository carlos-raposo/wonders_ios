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
    @State private var showLogin = false
    @State private var showSignup = false
    @State private var showForgotPassword = false
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var languageSettings = LanguageSettings()

    var body: some View {
        Group {
            if !isAuthenticated {
                AuthenticationFlowView(
                    showLogin: $showLogin,
                    showSignup: $showSignup,
                    showForgotPassword: $showForgotPassword,
                    onAuthenticated: { isAuthenticated = true }
                )
            } else {
                NavigationStack {
                    MainTabView()
                }
            }
        }
        .environmentObject(favoritesManager)
        .environmentObject(languageSettings)
        .background(
            colorScheme == .dark ? WondersTheme.darkBackground : WondersTheme.lightBackground
        )
        .ignoresSafeArea()
    }
}

// MARK: - Authentication Flow
struct AuthenticationFlowView: View {
    @Binding var showLogin: Bool
    @Binding var showSignup: Bool
    @Binding var showForgotPassword: Bool
    var onAuthenticated: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Lottie Animation Placeholder
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 180)
                    .overlay(Text("Lottie").font(.title2).foregroundColor(.gray))
                    .shadow(radius: 8)

                Text("Wonders")
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundColor(Color.primary)
                    .padding(.bottom, 8)

                Text("Welcome! Discover the wonders of the world.")
                    .font(.title3)
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 16) {
                    Button(action: { showLogin = true }) {
                        Text("Login")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(WondersTheme.buttonBlue)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(radius: 2)
                    }
                    Button(action: { showSignup = true }) {
                        Text("Sign Up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(WondersTheme.buttonBlue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(radius: 2)
                    }
                    Button(action: { showForgotPassword = true }) {
                        Text("Forgot Password?")
                            .font(.subheadline)
                            .foregroundColor(WondersTheme.buttonBlue)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationDestination(isPresented: $showLogin) {
                LoginView(onAuthenticated: onAuthenticated)
            }
            .navigationDestination(isPresented: $showSignup) {
                SignupView(onAuthenticated: onAuthenticated)
            }
            .navigationDestination(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}

// MARK: - Authentication Screens (Custom UI)
// (ForgotPasswordView, InstructionsView are now in their own files)

#Preview {
    ContentView()
}
