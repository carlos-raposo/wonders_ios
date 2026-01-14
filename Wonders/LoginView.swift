import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore

struct LoginView: View {
    var onAuthenticated: () -> Void
    @EnvironmentObject var languageSettings: LanguageSettings
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showSignUp = false
    @State private var errorMessage: String? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var notificationObserver: NSObjectProtocol?

    private let translations: [String: [String: String]] = [
        "en": [
            "login_title": "Sign In",
            "email_placeholder": "Email",
            "password_placeholder": "Password",
            "login_button": "Sign In",
            "google_button": "Continue with Google",
            "have_account": "Don't have an account? Sign up"
        ],
        "pt": [
            "login_title": "Entrar",
            "email_placeholder": "Email",
            "password_placeholder": "Senha",
            "login_button": "Entrar",
            "google_button": "Continuar com Google",
            "have_account": "Ainda não tem conta? Criar conta"
        ]
    ]
    private func t(_ key: String) -> String {
        translations[languageSettings.language]?[key] ?? translations["en"]![key]!
    }

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)

            Text(t("login_title"))
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 8)

            VStack(spacing: 16) {
                WondersTextField(icon: "envelope", placeholder: t("email_placeholder"), text: $email, isSecure: false)
                WondersTextField(icon: "lock", placeholder: t("password_placeholder"), text: $password, isSecure: !isPasswordVisible, trailingIcon: isPasswordVisible ? "eye.slash" : "eye", trailingAction: { isPasswordVisible.toggle() })
            }
            .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    } else {
                        self.errorMessage = nil
                        onAuthenticated()
                    }
                }
            }) {
                Text(t("login_button"))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 2)
            }
            .padding(.horizontal)

            SignInWithAppleButtonView(onAuthenticated: onAuthenticated, errorMessage: $errorMessage)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .padding(.horizontal)

            Button(action: {
                if let rootVC = UIApplication.topViewController() {
                    GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signInResult, error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            return
                        }
                        guard let user = signInResult?.user,
                              let idToken = user.idToken?.tokenString else {
                            self.errorMessage = NSLocalizedString("error_google_auth_failed", comment: "")
                            return
                        }
                        let accessToken = user.accessToken.tokenString
                        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                        Auth.auth().signIn(with: credential) { authResult, error in
                            if let error = error {
                                self.errorMessage = error.localizedDescription
                            } else {
                                self.errorMessage = nil
                                onAuthenticated()
                                NotificationCenter.default.post(name: .googleSignInSuccess, object: nil)
                            }
                        }
                    }
                }
            }) {
                HStack {
                    Image(systemName: "g.circle")
                        .foregroundColor(.red)
                    Text(NSLocalizedString("google_button", comment: ""))
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            .padding(.horizontal)

            Spacer()

            Button(action: { showSignUp = true }) {
                Text(t("have_account"))
                    .foregroundColor(Color.purple)
                    .font(.body)
            }
            .padding(.bottom)
            .sheet(isPresented: $showSignUp) {
                SignupView(onAuthenticated: onAuthenticated)
                    .environmentObject(languageSettings)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            notificationObserver = NotificationCenter.default.addObserver(forName: .googleSignInSuccess, object: nil, queue: .main) { _ in
                onAuthenticated()
            }
        }
        .onDisappear {
            if let observer = notificationObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
}

// Helper to get the current UIViewController from SwiftUI
extension UIApplication {
    static func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
