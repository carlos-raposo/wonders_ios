import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = true
    @AppStorage("isDarkMode") var isDarkMode: Bool = false // Persist dark mode
    @State private var errorMessage: String?
    @State private var userName: String? = nil
    @State private var isLoadingName = false
    @EnvironmentObject var languageSettings: LanguageSettings
    @State private var showLanguageSheet = false
    @State private var showTutorial = false
    @State private var showContact = false
    @State private var showPrivacy = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: Int
    var showBackButton: Bool = false

    var user: User? {
        Auth.auth().currentUser
    }

    private let translations: [String: [String: String]] = [
        "en": [
            "account": "Account",
            "settings": "Settings",
            "help": "Help",
            "logout": "Logout",
            "delete_account": "Delete Account",
            "switch_dark": "Switch to dark mode",
            "language": "Language",
            "tutorial": "Tutorial",
            "contact": "Contact",
            "privacy": "Privacy Policy",
            "delete_title": "Delete Account",
            "delete_message": "Are you sure you want to delete your account? This action cannot be undone.",
            "delete_confirm": "Delete",
            "cancel": "Cancel",
            "select_language": "Select Language",
            "user": "User"
        ],
        "pt": [
            "account": "Conta",
            "settings": "Configurações",
            "help": "Ajuda",
            "logout": "Sair",
            "delete_account": "Excluir Conta",
            "switch_dark": "Alternar modo escuro",
            "language": "Idioma",
            "tutorial": "Tutorial",
            "contact": "Contato",
            "privacy": "Política de Privacidade",
            "delete_title": "Excluir Conta",
            "delete_message": "Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.",
            "delete_confirm": "Excluir",
            "cancel": "Cancelar",
            "select_language": "Selecionar Idioma",
            "user": "Usuário"
        ]
    ]
    
    private func t(_ key: String) -> String {
        translations[languageSettings.language]?[key] ?? translations["en"]![key]!
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Account Header
                VStack(spacing: 12) {
                    HStack {
                        if showBackButton {
                            Button(action: {
                                // Se for modal/push, tente dismiss, senão volte para Home
                                if #available(iOS 15.0, *) {
                                    dismiss()
                                } else {
                                    selectedTab = 0
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .padding(.trailing, 8)
                            }
                        }
                        Spacer()
                    }
                    Text(t("account"))
                        .font(.system(size: 32, weight: .bold))
                        .padding(.top, 8)
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(Color(.systemBlue).opacity(0.2)) // Adaptive blue
                            .frame(width: 120, height: 120)
                        Text(userInitial)
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(Color(.systemBlue)) // Adaptive blue
                    }
                    // Name and edit
                    HStack(spacing: 6) {
                        Text(userName ?? user?.displayName ?? t("user"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Image(systemName: "pencil")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    // Email
                    Text(user?.email ?? "-")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                // Settings Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(t("settings"))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading, 4)
                        .foregroundColor(.primary)
                    CardButton(icon: "moon.fill", text: t("switch_dark"), isDestructive: false) {
                        isDarkMode.toggle()
                    }
                    CardButton(icon: "globe", text: t("language"), trailing: Text(languageDisplayName).foregroundColor(.gray)) {
                        showLanguageSheet = true
                    }
                }
                // Help Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(t("help"))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading, 4)
                        .foregroundColor(.primary)
                    CardButton(icon: "questionmark.circle", text: t("tutorial"), isDestructive: false) {
                        showTutorial = true
                    }
                    CardButton(icon: "envelope", text: t("contact"), isDestructive: false) {
                        showContact = true
                    }
                    CardButton(icon: "shield", text: t("privacy"), isDestructive: false) {
                        showPrivacy = true
                    }
                }
                // Account Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(t("account"))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading, 4)
                        .foregroundColor(.primary)
                    CardButton(icon: "arrowshape.turn.up.left", text: t("logout"), isDestructive: false) {
                        logout()
                    }
                    CardButton(icon: "trash", text: t("delete_account"), isDestructive: true) {
                        showDeleteAlert = true
                    }
                }
            }
            .padding(.horizontal)
            .onAppear(perform: loadUserName)
        }
        .actionSheet(isPresented: $showLanguageSheet) {
            ActionSheet(title: Text(t("select_language")), buttons: [
                .default(Text("English")) { languageSettings.language = "en" },
                .default(Text("Portuguese")) { languageSettings.language = "pt" },
                .cancel(Text(t("cancel")))
            ])
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text(t("delete_title")), message: Text(t("delete_message")), primaryButton: .destructive(Text(t("delete_confirm"))) {
                // TODO: Implement delete
            }, secondaryButton: .cancel(Text(t("cancel"))))
        }
        .sheet(isPresented: $showTutorial) {
            TutorialView()
        }
    }

    private var userInitial: String {
        if let name = userName ?? user?.displayName, let first = name.first {
            return String(first).uppercased()
        }
        return "U"
    }

    private var languageDisplayName: String {
        switch languageSettings.language {
        case "pt": return "Portuguese"
        case "en": return "English"
        default: return languageSettings.language.capitalized
        }
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
                    .fill(Color(.systemBackground)) // Adaptive background
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isDestructive ? Color.red : Color(.separator), lineWidth: isDestructive ? 2 : 1)
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
    SettingsView(selectedTab: .constant(1))
}
