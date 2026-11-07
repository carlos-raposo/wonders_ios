import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import AuthenticationServices

struct SignupView: View {
    var onAuthenticated: () -> Void
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var showLogin = false
    @State private var errorMessage: String? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    // Controlo de exibição do Tutorial no final do Registo
    @AppStorage("dontShowInstructions") private var dontShowInstructions = false
    @State private var showTutorialModal = false
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var languageSettings: LanguageSettings

    private let translations: [String: [String: String]] = [
        "en": [
            "signup_title": "Sign Up",
            "name_placeholder": "Name",
            "email_placeholder": "Email",
            "password_placeholder": "Password",
            "confirm_password_placeholder": "Confirm Password",
            "signup_button": "Sign Up",
            "error_passwords_no_match": "Passwords do not match.",
            "google_button": "Sign Up with Google",
            "have_account": "Already have an account? Sign in",
            "privacy": "Privacy Policy"
        ],
        "pt": [
            "signup_title": "Criar Conta",
            "name_placeholder": "Nome",
            "email_placeholder": "Email",
            "password_placeholder": "Senha",
            "confirm_password_placeholder": "Confirmar Senha",
            "signup_button": "Criar Conta",
            "error_passwords_no_match": "As senhas não coincidem.",
            "google_button": "Criar conta com Google",
            "have_account": "Já tem conta? Entrar",
            "privacy": "Política de Privacidade"
        ],
        "fr": [
            "signup_title": "Créer un compte",
            "name_placeholder": "Nom",
            "email_placeholder": "E-mail",
            "password_placeholder": "Mot de passe",
            "confirm_password_placeholder": "Confirmer le mot de passe",
            "signup_button": "Créer un compte",
            "error_passwords_no_match": "Les mots de passe ne correspondent pas.",
            "google_button": "Créer un compte avec Google",
            "have_account": "Vous avez déjà un compte ? Connectez-vous",
            "privacy": "Politique de confidentialité"
        ],
        "es": [
            "signup_title": "Crear cuenta",
            "name_placeholder": "Nombre",
            "email_placeholder": "Correo electrónico",
            "password_placeholder": "Contraseña",
            "confirm_password_placeholder": "Confirmar contraseña",
            "signup_button": "Crear cuenta",
            "error_passwords_no_match": "Las contraseñas no coinciden.",
            "google_button": "Crear cuenta con Google",
            "have_account": "¿Ya tienes una cuenta? Iniciar sesión",
            "privacy": "Política de privacidad"
        ]
    ]
    
    private func t(_ key: String) -> String {
        translations[languageSettings.language]?[key] ?? translations["en"]![key]!
    }

    private func handleSuccessfulAuth() {
        let userUid = Auth.auth().currentUser?.uid ?? ""
        let hasSeenTutorialForUser = UserDefaults.standard.bool(forKey: "has_seen_tutorial_\(userUid)")
        
        if !dontShowInstructions && !hasSeenTutorialForUser {
            showTutorialModal = true
        } else {
            onAuthenticated()
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
                        Text(t("signup_title"))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.bottom, 8)

                        VStack(spacing: 16) {
                            WondersTextField(icon: "person", placeholder: t("name_placeholder"), text: $name, isSecure: false)
                            WondersTextField(icon: "envelope", placeholder: t("email_placeholder"), text: $email, isSecure: false)
                            WondersTextField(icon: "lock", placeholder: t("password_placeholder"), text: $password, isSecure: !isPasswordVisible, trailingIcon: isPasswordVisible ? "eye.slash" : "eye", trailingAction: { isPasswordVisible.toggle() })
                            WondersTextField(icon: "lock", placeholder: t("confirm_password_placeholder"), text: $confirmPassword, isSecure: !isConfirmPasswordVisible, trailingIcon: isConfirmPasswordVisible ? "eye.slash" : "eye", trailingAction: { isConfirmPasswordVisible.toggle() })
                        }

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        // Botão Criar Conta (Principal)
                        Button(action: {
                            guard password == confirmPassword else {
                                errorMessage = t("error_passwords_no_match")
                                return
                            }
                            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                                if let error = error {
                                    self.errorMessage = error.localizedDescription
                                } else {
                                    self.errorMessage = nil
                                    let db = Firestore.firestore()
                                    db.collection("users").document(result!.user.uid).setData([
                                        "name": name,
                                        "email": email,
                                        "createdAt": FieldValue.serverTimestamp(),
                                        "lastLogin": FieldValue.serverTimestamp(),
                                        "authProvider": "local",
                                        "photoURL": ""
                                    ]) { error in
                                        if let error = error {
                                            self.errorMessage = error.localizedDescription
                                        } else {
                                            self.errorMessage = nil
                                            handleSuccessfulAuth()
                                        }
                                    }
                                }
                            }
                        }) {
                            Text(t("signup_button"))
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(red: 0x51 / 255.0, green: 0xA0 / 255.0, blue: 0xCE / 255.0)) // Cor #FF51A0CE
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        .frame(maxWidth: 440)

                        // Botão Apple perfeitamente padronizado
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(colorScheme == .dark ? Color.white : Color.black)
                            
                            HStack(spacing: 8) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 18, weight: .medium))
                                Text(languageSettings.language == "pt" ? "Entrar com a Apple" : "Sign in with Apple")
                                    .font(.system(size: 18, weight: .medium))
                            }
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(colorScheme == .dark ? Color.black.opacity(0.4) : Color.black.opacity(0.3), lineWidth: 1)
                        )
                        .overlay(
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
                                                    let db = Firestore.firestore()
                                                    let userRef = db.collection("users").document(authResult!.user.uid)
                                                    userRef.getDocument { document, error in
                                                        if let document = document, document.exists {
                                                            handleSuccessfulAuth()
                                                        } else {
                                                            userRef.setData([
                                                                "name": authResult?.user.displayName ?? "",
                                                                "email": authResult?.user.email ?? "",
                                                                "createdAt": FieldValue.serverTimestamp(),
                                                                "lastLogin": FieldValue.serverTimestamp(),
                                                                "authProvider": "apple",
                                                                "photoURL": ""
                                                            ]) { _ in
                                                                handleSuccessfulAuth()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    case .failure(let error):
                                        self.errorMessage = error.localizedDescription
                                    }
                                }
                            )
                            .blendMode(.normal)
                            .opacity(0.01) // Invisível mas deteta o toque a 100%
                        )
                        .frame(maxWidth: 440)
                        .padding(.horizontal, 2)

                        // Botão Google Otimizado com o ícone colorido personalizado igual ao de login
                        Button(action: {
                            if let rootVC = UIApplication.shared.topViewController {
                                GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signInResult, error in
                                    if let error = error {
                                        self.errorMessage = error.localizedDescription
                                        return
                                    }
                                    guard let user = signInResult?.user,
                                          let idToken = user.idToken?.tokenString else {
                                        self.errorMessage = "Google authentication failed."
                                        return
                                    }
                                    let accessToken = user.accessToken.tokenString
                                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                                    Auth.auth().signIn(with: credential) { authResult, error in
                                        if let error = error {
                                            self.errorMessage = error.localizedDescription
                                        } else if let authResult = authResult {
                                            let db = Firestore.firestore()
                                            let userRef = db.collection("users").document(authResult.user.uid)
                                            userRef.getDocument { document, error in
                                                if let document = document, document.exists {
                                                    self.errorMessage = nil
                                                    handleSuccessfulAuth()
                                                } else {
                                                    userRef.setData([
                                                        "name": authResult.user.displayName ?? "",
                                                        "email": authResult.user.email ?? "",
                                                        "createdAt": FieldValue.serverTimestamp(),
                                                        "lastLogin": FieldValue.serverTimestamp(),
                                                        "authProvider": "google",
                                                        "photoURL": authResult.user.photoURL?.absoluteString ?? ""
                                                    ]) { error in
                                                        if let error = error {
                                                            self.errorMessage = error.localizedDescription
                                                        } else {
                                                            self.errorMessage = nil
                                                            handleSuccessfulAuth()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image("g") // Utiliza o asset vetorial "g" com transparência perfeita
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                                Text(t("google_button"))
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
                        Button(action: { showLogin = true }) {
                            Text(t("have_account"))
                                .foregroundColor(Color(red: 0x51 / 255.0, green: 0xA0 / 255.0, blue: 0xCE / 255.0)) // Cor #FF51A0CE
                                .font(.body)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 8)

                        Button(action: {
                            let urlString: String
                            switch languageSettings.language {
                            case "pt":
                                urlString = "https://app.sevenwonders.pt/pt/apps/lisboasevenwonders/politica-privacidade"
                            case "es":
                                urlString = "https://app.sevenwonders.pt/es/apps/lisboasevenwonders/politica-privacidade"
                            case "fr":
                                urlString = "https://app.sevenwonders.pt/fr/apps/lisboasevenwonders/politica-privacidade"
                            default:
                                urlString = "https://app.sevenwonders.pt/fr/apps/lisboasevenwonders/politique-confidentialite"
                            }
                            
                            if let url = URL(string: urlString) {
                                UIApplication.shared.open(url)
                            }
                        }){
                            Text(t("privacy"))
                                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.9) : Color.black.opacity(0.9))
                                .font(.body)
                                .underline()
                        }
                        .padding(.top, 4)
                    }
                    .frame(maxWidth: 440)
                    .padding(.horizontal, 24)

                    Spacer(minLength: 20)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(onAuthenticated: onAuthenticated)
                .environmentObject(languageSettings)
        }
        .fullScreenCover(isPresented: $showTutorialModal, onDismiss: {
            onAuthenticated()
        }) {
            TutorialView(isFirstLaunch: true, canSkip: true)
                .environmentObject(languageSettings)
        }
    }
}
