import SwiftUI
import FirebaseAuth

struct LoginView: View {
    var onAuthenticated: () -> Void
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showSignUp = false
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

            Button(action: { /* Google sign-in */ }) {
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
    }
}
