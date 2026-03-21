import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

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

            Text(t("signup_title"))
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 8)

            VStack(spacing: 16) {
                WondersTextField(icon: "person", placeholder: t("name_placeholder"), text: $name, isSecure: false)
                WondersTextField(icon: "envelope", placeholder: t("email_placeholder"), text: $email, isSecure: false)
                WondersTextField(icon: "lock", placeholder: t("password_placeholder"), text: $password, isSecure: !isPasswordVisible, trailingIcon: isPasswordVisible ? "eye.slash" : "eye", trailingAction: { isPasswordVisible.toggle() })
                WondersTextField(icon: "lock", placeholder: t("confirm_password_placeholder"), text: $confirmPassword, isSecure: !isConfirmPasswordVisible, trailingIcon: isConfirmPasswordVisible ? "eye.slash" : "eye", trailingAction: { isConfirmPasswordVisible.toggle() })
            }
            .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

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
                                onAuthenticated()
                            }
                        }
                    }
                }
            }) {
                Text(t("signup_button"))
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
                                        onAuthenticated()
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
                                                onAuthenticated()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }) {
                HStack {
                    Image(systemName: "g.circle")
                        .foregroundColor(.red)
                    Text(t("google_button"))
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            .padding(.horizontal)

            Button(action: { showLogin = true }) {
                Text(t("have_account"))
                    .foregroundColor(Color.purple)
                    .font(.body)
            }
            .padding(.bottom)
            .sheet(isPresented: $showLogin) {
                LoginView(onAuthenticated: onAuthenticated)
                    .environmentObject(languageSettings)
            }
            Button(action: {
                let urlString = languageSettings.language == "pt" ? "https://app.sevenwonders.pt/politica-privacidade.html" : "https://app.sevenwonders.pt/privacy-policy.html"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text(t("privacy"))
                    .foregroundColor(.blue)
                    .font(.body)
                    .underline()
            }
            .padding(.bottom, 8)
        }
        .navigationBarBackButtonHidden(true)
    }
}
