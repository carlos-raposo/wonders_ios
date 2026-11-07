import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore
import AuthenticationServices

// MARK: - Extension Helper para PurchaseManager
extension PurchaseManager {
    var isPremium: Bool {
        return Auth.auth().currentUser != nil
    }
}

struct LoginView: View {
    var onAuthenticated: () -> Void
    @EnvironmentObject var languageSettings: LanguageSettings
    @Environment(\.colorScheme) var colorScheme
    
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showSignUp = false
    @State private var errorMessage: String? = nil
    
    // Controlo de exibição do Tutorial no final da Autenticação
    @AppStorage("dontShowInstructions") private var dontShowInstructions = false
    @State private var showTutorialModal = false
    
    @Environment(\.dismiss) private var dismiss
    @State private var notificationObserver: NSObjectProtocol?

    private let translations: [String: [String: String]] = [
        "en": [
            "login_title": "Sign In",
            "email_placeholder": "Email",
            "password_placeholder": "Password",
            "login_button": "Sign In",
            "apple_button": "Sign in with Apple",
            "google_button": "Continue with Google",
            "have_account": "Don't have an account? Sign up"
        ],
        "pt": [
            "login_title": "Entrar",
            "email_placeholder": "Email",
            "password_placeholder": "Senha",
            "login_button": "Entrar",
            "apple_button": "Entrar com a Apple",
            "google_button": "Continuar com Google",
            "have_account": "Ainda não tem conta? Criar conta"
        ],
        "fr": [
            "login_title": "Connexion",
            "email_placeholder": "E-mail",
            "password_placeholder": "Mot de passe",
            "login_button": "Connexion",
            "apple_button": "Se connecter avec Apple",
            "google_button": "Continuer avec Google",
            "have_account": "Vous n'avez pas de compte ? Créer un compte"
        ],
        "es": [
            "login_title": "Iniciar sesión",
            "email_placeholder": "Correo electrónico",
            "password_placeholder": "Contraseña",
            "login_button": "Iniciar sesión",
            "google_button": "Continuar con Google",
            "have_account": "¿No tienes cuenta? Crear cuenta"
        ]
    ]
    
    private func t(_ key: String) -> String {
        translations[languageSettings.language]?[key] ?? translations["en"]![key]!
    }

    private func handleSuccessfulAuth() {
        Task {
            await PurchaseManager.shared.checkUserFirestoreStatus()
            DispatchQueue.main.async {
                let userUid = Auth.auth().currentUser?.uid ?? ""
                let hasSeenTutorialForUser = UserDefaults.standard.bool(forKey: "has_seen_tutorial_\(userUid)")
                
                if !dontShowInstructions && !hasSeenTutorialForUser {
                    showTutorialModal = true
                } else {
                    onAuthenticated()
                }
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    Spacer(minLength: 10)

                    // Bloco central com limite de largura adaptado para Tablets/iPad
                    VStack(spacing: 24) {
                        Text(t("login_title"))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.bottom, 8)

                        VStack(spacing: 16) {
                            WondersTextField(icon: "envelope", placeholder: t("email_placeholder"), text: $email, isSecure: false)
                            WondersTextField(icon: "lock", placeholder: t("password_placeholder"), text: $password, isSecure: !isPasswordVisible, trailingIcon: isPasswordVisible ? "eye.slash" : "eye", trailingAction: { isPasswordVisible.toggle() })
                        }

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        // Botão Entrar (Email/Password)
                        Button(action: {
                            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                                if let error = error {
                                    self.errorMessage = error.localizedDescription
                                } else {
                                    self.errorMessage = nil
                                    handleSuccessfulAuth()
                                }
                            }
                        }) {
                            Text(t("login_button"))
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(red: 0x51 / 255.0, green: 0xA0 / 255.0, blue: 0xCE / 255.0)) // Cor #FF51A0CE
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        .frame(maxWidth: 440)
                        
                        // Botão Apple com moldura e contorno visível idêntico ao da Google
                        SignInWithAppleButton(
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: { result in
                                switch result {
                                case .success(let authorization):
                                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                        guard let tokenData = appleIDCredential.identityToken,
                                              let tokenString = String(data: tokenData, encoding: .utf8) else {
                                            self.errorMessage = "Não foi possível processar o token da Apple."
                                            return
                                        }
                                        
                                        let credential = OAuthProvider.appleCredential(
                                            withIDToken: tokenString,
                                            rawNonce: "",
                                            fullName: appleIDCredential.fullName
                                        )
                                        
                                        Auth.auth().signIn(with: credential) { authResult, error in
                                            if let error = error {
                                                self.errorMessage = error.localizedDescription
                                            } else {
                                                self.errorMessage = nil
                                                handleSuccessfulAuth()
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    self.errorMessage = error.localizedDescription
                                }
                            }
                        )
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .whiteOutline : .black)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(16)
                        // Aplica uma moldura/contorno exterior rigoroso para igualar o peso visual do botão Google
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(colorScheme == .dark ? Color.white.opacity(1) : Color.black.opacity(1), lineWidth: 1)
                        )
                        .frame(maxWidth: 440)

                        // Botão Google Otimizado com o ícone colorido personalizado
                        Button(action: {
                            if let rootVC = UIApplication.shared.topViewController {
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
                                            handleSuccessfulAuth()
                                            NotificationCenter.default.post(name: .googleSignInSuccess, object: nil)
                                        }
                                    }
                                }
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image("g") // Utiliza o asset vetorial "g" que colocou no Xcode
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                
                                Text(NSLocalizedString("google_button", comment: ""))
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(colorScheme == .dark ? Color(white: 0.18) : Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(colorScheme == .dark ? Color.black.opacity(0.4) : Color.black.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .frame(maxWidth: 440)
                        .padding(.horizontal, 2)

                        Button(action: { showSignUp = true }) {
                            Text(t("have_account"))
                                .foregroundColor(Color(red: 0x51 / 255.0, green: 0xA0 / 255.0, blue: 0xCE / 255.0)) // Cor #FF51A0CE
                                .font(.body)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: 440)
                    .padding(.horizontal, 24)

                    Spacer(minLength: 20)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            notificationObserver = NotificationCenter.default.addObserver(forName: .googleSignInSuccess, object: nil, queue: .main) { _ in
                handleSuccessfulAuth()
            }
        }
        .onDisappear {
            if let observer = notificationObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignupView(onAuthenticated: {
                handleSuccessfulAuth()
            })
            .environmentObject(languageSettings)
        }
        .fullScreenCover(isPresented: $showTutorialModal, onDismiss: {
            onAuthenticated()
        }) {
            TutorialView(
                isPremium: PurchaseManager.shared.isPremium,
                isFirstLaunch: true,
                canSkip: true
            )
            .environmentObject(languageSettings)
        }
    }
}

// MARK: - Extension Helper para topViewController em UIApplication
extension UIApplication {
    var topViewController: UIViewController? {
        guard let scene = connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }
        return findTopViewController(from: root)
    }

    private func findTopViewController(from vc: UIViewController?) -> UIViewController? {
        if let nav = vc as? UINavigationController {
            return findTopViewController(from: nav.visibleViewController)
        }
        if let tab = vc as? UITabBarController {
            return findTopViewController(from: tab.selectedViewController)
        }
        if let presented = vc?.presentedViewController {
            return findTopViewController(from: presented)
        }
        return vc
    }
}
