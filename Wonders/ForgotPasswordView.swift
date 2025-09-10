import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil
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

            Text("Recuperar Senha")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 8)

            WondersTextField(icon: "envelope", placeholder: "Email", text: $email, isSecure: false)
                .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.caption)
            }

            Button(action: {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.successMessage = nil
                    } else {
                        self.errorMessage = nil
                        self.successMessage = "Instruções enviadas para o seu email."
                    }
                }
            }) {
                Text("Enviar instruções")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 2)
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}
