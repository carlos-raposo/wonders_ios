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

            Text(NSLocalizedString("signup_title", comment: ""))
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 8)

            VStack(spacing: 16) {
                WondersTextField(icon: "person", placeholder: NSLocalizedString("name_placeholder", comment: ""), text: $name, isSecure: false)
                WondersTextField(icon: "envelope", placeholder: NSLocalizedString("email_placeholder", comment: ""), text: $email, isSecure: false)
                WondersTextField(icon: "lock", placeholder: NSLocalizedString("password_placeholder", comment: ""), text: $password, isSecure: !isPasswordVisible, trailingIcon: isPasswordVisible ? "eye.slash" : "eye", trailingAction: { isPasswordVisible.toggle() })
                WondersTextField(icon: "lock", placeholder: NSLocalizedString("confirm_password_placeholder", comment: ""), text: $confirmPassword, isSecure: !isConfirmPasswordVisible, trailingIcon: isConfirmPasswordVisible ? "eye.slash" : "eye", trailingAction: { isConfirmPasswordVisible.toggle() })
            }
            .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: {
                guard password == confirmPassword else {
                    errorMessage = NSLocalizedString("error_passwords_no_match", comment: "")
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
                Text(NSLocalizedString("signup_button", comment: ""))
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
                            self.errorMessage = NSLocalizedString("error_google_auth_failed", comment: "")
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

            Button(action: { showLogin = true }) {
                Text(NSLocalizedString("have_account", comment: ""))
                    .foregroundColor(Color.purple)
                    .font(.body)
            }
            .padding(.bottom)
            .sheet(isPresented: $showLogin) {
                LoginView(onAuthenticated: onAuthenticated)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
