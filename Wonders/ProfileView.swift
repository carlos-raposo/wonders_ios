import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = true
    @State private var errorMessage: String?

    var user: User? {
        Auth.auth().currentUser
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if let user = user {
                    Text("Perfil")
                        .font(.largeTitle)
                        .bold()
                    Text("Email: \(user.email ?? "-")")
                        .font(.title3)
                        .padding(.bottom, 8)
                } else {
                    Text("Usuário não autenticado.")
                        .foregroundColor(.red)
                }
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Spacer()
                Button(action: logout) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            isUserLoggedIn = false
        } catch {
            errorMessage = "Erro ao fazer logout: \(error.localizedDescription)"
        }
    }
}

#Preview {
    ProfileView()
}
