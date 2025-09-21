import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore

struct LoginView: View {
    var onAuthenticated: () -> Void
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showSignUp = false
    @State private var errorMessage: String? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var notificationObserver: NSObjectProtocol?

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

            Text("Entrar")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 8)

            VStack(spacing: 16) {
                WondersTextField(icon: "envelope", placeholder: "Email", text: $email, isSecure: false)
                WondersTextField(icon: "lock", placeholder: "Senha", text: $password, isSecure: !isPasswordVisible, trailingIcon: isPasswordVisible ? "eye.slash" : "eye", trailingAction: { isPasswordVisible.toggle() })
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
                Text("Entrar")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 2)
            }
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
                    Text("Continue with Google")
                        .foregroundColor(Color.purple)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
            .padding(.horizontal)

            Spacer()

            Button(action: { showSignUp = true }) {
                Text("Não tem uma conta? Cadastre-se")
                    .foregroundColor(Color.purple)
                    .font(.body)
            }
            .padding(.bottom)
            .sheet(isPresented: $showSignUp) {
                SignupView(onAuthenticated: onAuthenticated)
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
