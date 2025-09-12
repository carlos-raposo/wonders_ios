import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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

            Text("Criar Conta")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 8)

            VStack(spacing: 16) {
                WondersTextField(icon: "person", placeholder: "Nome", text: $name, isSecure: false)
                WondersTextField(icon: "envelope", placeholder: "Email", text: $email, isSecure: false)
                WondersTextField(icon: "lock", placeholder: "Senha", text: $password, isSecure: !isPasswordVisible, trailingIcon: isPasswordVisible ? "eye.slash" : "eye", trailingAction: { isPasswordVisible.toggle() })
                WondersTextField(icon: "lock", placeholder: "Confirmar Senha", text: $confirmPassword, isSecure: !isConfirmPasswordVisible, trailingIcon: isConfirmPasswordVisible ? "eye.slash" : "eye", trailingAction: { isConfirmPasswordVisible.toggle() })
            }
            .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: {
                guard password == confirmPassword else {
                    errorMessage = "As senhas não coincidem."
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
                Text("Criar Conta")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 2)
            }
            .padding(.horizontal)

            Button(action: { /* Google sign-up */ }) {
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

            Button(action: { showLogin = true }) {
                Text("Já tem uma conta? Entre")
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
