import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = true
    @State private var errorMessage: String?
    @State private var userName: String? = nil
    @State private var isLoadingName = false
    @State private var isDarkMode = false
    @State private var language = "English"
    @State private var showLanguageSheet = false
    @State private var showTutorial = false
    @State private var showContact = false
    @State private var showPrivacy = false
    @State private var showDeleteAlert = false

    var user: User? {
        Auth.auth().currentUser
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Account Header
                VStack(spacing: 12) {
                    Text("Account")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.top, 24)
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 120, height: 120)
                        Text(userInitial)
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    // Name and edit
                    HStack(spacing: 6) {
                        Text(userName ?? user?.displayName ?? "User")
                            .font(.title2)
                            .fontWeight(.bold)
                        Image(systemName: "pencil")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    // Email
                    Text(user?.email ?? "-")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                // Settings Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Settings")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading, 4)
                    CardButton(icon: "moon.fill", text: "Switch to dark mode", isDestructive: false) {
                        isDarkMode.toggle()
                    }
                    CardButton(icon: "globe", text: "Language", trailing: Text(language).foregroundColor(.gray)) {
                        showLanguageSheet = true
                    }
                }
                // Help Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Help")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading, 4)
                    CardButton(icon: "questionmark.circle", text: "Tutorial", isDestructive: false) {
                        showTutorial = true
                    }
                    CardButton(icon: "envelope", text: "Contact", isDestructive: false) {
                        showContact = true
                    }
                    CardButton(icon: "shield", text: "Privacy Policy", isDestructive: false) {
                        showPrivacy = true
                    }
                }
                // Account Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading, 4)
                    CardButton(icon: "arrowshape.turn.up.left", text: "Logout", isDestructive: false) {
                        logout()
                    }
                    CardButton(icon: "trash", text: "Delete Account", isDestructive: true) {
                        showDeleteAlert = true
                    }
                }
            }
            .padding(.horizontal)
            .onAppear(perform: loadUserName)
        }
        .actionSheet(isPresented: $showLanguageSheet) {
            ActionSheet(title: Text("Select Language"), buttons: [
                .default(Text("English")) { language = "English" },
                .default(Text("Portuguese")) { language = "Portuguese" },
                .cancel()
            ])
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Delete Account"), message: Text("Are you sure you want to delete your account? This action cannot be undone."), primaryButton: .destructive(Text("Delete")) {
                // TODO: Implement delete
            }, secondaryButton: .cancel())
        }
    }

    private var userInitial: String {
        if let name = userName ?? user?.displayName, let first = name.first {
            return String(first).uppercased()
        }
        return "U"
    }

    private func loadUserName() {
        guard let user = user else { return }
        isLoadingName = true
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            isLoadingName = false
            if let error = error {
                errorMessage = "Error loading name: \(error.localizedDescription)"
            } else if let data = snapshot?.data(), let name = data["name"] as? String {
                userName = name
            } else {
                userName = nil
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            isUserLoggedIn = false
        } catch {
            errorMessage = "Error logging out: \(error.localizedDescription)"
        }
    }
}

struct CardButton<Trailing: View>: View {
    let icon: String
    let text: String
    let trailing: Trailing
    var isDestructive: Bool = false
    var action: () -> Void

    init(icon: String, text: String, trailing: Trailing, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.text = text
        self.trailing = trailing
        self.isDestructive = isDestructive
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : .primary)
                Text(text)
                    .foregroundColor(isDestructive ? .red : .primary)
                Spacer()
                trailing
                Image(systemName: "chevron.right")
                    .foregroundColor(isDestructive ? .red : .gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isDestructive ? Color.red : Color.gray.opacity(0.2), lineWidth: isDestructive ? 2 : 1)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                    )
            )
        }
    }
}

extension CardButton where Trailing == EmptyView {
    init(icon: String, text: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.init(icon: icon, text: text, trailing: EmptyView(), isDestructive: isDestructive, action: action)
    }
}

#Preview {
    SettingsView()
}
