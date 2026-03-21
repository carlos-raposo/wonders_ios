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
    @Binding var showLogin: Bool
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
            "switch_light": "Switch to light mode",
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
            "switch_dark": "Alternar para modo escuro",
            "switch_light": "Alternar para modo claro",
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
        ],
        "fr": [
            "account": "Compte",
            "settings": "Paramètres",
            "help": "Aide",
            "logout": "Déconnexion",
            "delete_account": "Supprimer le compte",
            "switch_dark": "Passer en mode sombre",
            "switch_light": "Passer en mode clair",
            "language": "Langue",
            "tutorial": "Tutoriel",
            "contact": "Contact",
            "privacy": "Politique de confidentialité",
            "delete_title": "Supprimer le compte",
            "delete_message": "Êtes-vous sûr de vouloir supprimer votre compte ? Cette action ne peut pas être annulée.",
            "delete_confirm": "Supprimer",
            "cancel": "Annuler",
            "select_language": "Sélectionner la langue",
            "user": "Utilisateur"
        ],
        "es": [
            "account": "Cuenta",
            "settings": "Configuración",
            "help": "Ayuda",
            "logout": "Cerrar sesión",
            "delete_account": "Eliminar cuenta",
            "switch_dark": "Cambiar a modo oscuro",
            "switch_light": "Cambiar a modo claro",
            "language": "Idioma",
            "tutorial": "Tutorial",
            "contact": "Contacto",
            "privacy": "Política de privacidad",
            "delete_title": "Eliminar cuenta",
            "delete_message": "¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.",
            "delete_confirm": "Eliminar",
            "cancel": "Cancelar",
            "select_language": "Seleccionar idioma",
            "user": "Usuario"
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
                    CardButton(icon: isDarkMode ? "sun.max.fill" : "moon.fill", text: t(isDarkMode ? "switch_light" : "switch_dark"), isDestructive: false) {
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
                        let urlString: String
                        if languageSettings.language == "pt" {
                            urlString = "https://app.sevenwonders.pt/politica-privacidade.html"
                        } else {
                            urlString = "https://app.sevenwonders.pt/privacy-policy.html"
                        }
                        if let url = URL(string: urlString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                // Account Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(t("account"))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading, 4)
                        .foregroundColor(.primary)
                    if isUserLoggedIn {
                        CardButton(icon: "arrowshape.turn.up.left", text: t("logout"), isDestructive: false) {
                            logout()
                        }
                        CardButton(icon: "trash", text: t("delete_account"), isDestructive: true) {
                            showDeleteAlert = true
                        }
                    } else {
                        CardButton(icon: "person.crop.circle.badge.plus", text: languageSettings.language == "pt" ? "Entrar" : "Login", isDestructive: false) {
                            // Open global login modal managed by ContentView
                            showLogin = true
                        }
                    }
                }
            }
            .padding(.horizontal)
            .onAppear(perform: loadUserName)
        }
        .actionSheet(isPresented: $showLanguageSheet) {
            ActionSheet(title: Text(t("select_language")), buttons: [
                .default(Text("English")) { languageSettings.language = "en" },
                .default(Text("Português")) { languageSettings.language = "pt" },
                .default(Text("Français")) { languageSettings.language = "fr" },
                .default(Text("Español")) { languageSettings.language = "es" },
                .cancel(Text(t("cancel")))
            ])
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text(t("delete_title")), message: Text(t("delete_message")), primaryButton: .destructive(Text(t("delete_confirm"))) {
                deleteAccount()
            }, secondaryButton: .cancel(Text(t("cancel"))))
        }
        .sheet(isPresented: $showTutorial) {
            TutorialView()
        }
        .sheet(isPresented: $showContact) {
            ContactSheetView(isPresented: $showContact)
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
        case "en": return "English"
        case "pt": return "Português"
        case "fr": return "Français"
        case "es": return "Español"
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

    private func deleteAccount() {
        guard let user = user else { return }
        // Delete Firestore user document first (optional)
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).delete { error in
            // Proceed to delete Firebase Auth user regardless of Firestore result
            user.delete { authError in
                if let authError = authError {
                    errorMessage = "Error deleting account: \(authError.localizedDescription)"
                } else {
                    isUserLoggedIn = false
                }
            }
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

struct ContactSheetView: View {
    @Binding var isPresented: Bool
    let iconWidth: CGFloat = 24
    let copyWidth: CGFloat = 24
    let rowHeight: CGFloat = 28
    var body: some View {
        VStack(spacing: 32) {
            Text("Contact")
                .font(.title2)
                .bold()
                .padding(.top, 16)
            VStack(spacing: 20) {
                // Email row
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "envelope")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                        .frame(width: iconWidth, alignment: .center)
                        .padding(.leading, 2)
                    Text("lisbonsevenwonders@gmail.com")
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minWidth: 140, maxWidth: .infinity, alignment: .center) // <-- centralizado
                    Button(action: {
                        UIPasteboard.general.string = "lisbonsevenwonders@gmail.com"
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                    .frame(width: copyWidth, alignment: .center)
                    .padding(.trailing, 2)
                }
                // Phone row
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "phone")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                        .frame(width: iconWidth, alignment: .center)
                        .padding(.leading, 2)
                    Text("+351 915122373")
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minWidth: 140, maxWidth: .infinity, alignment: .center) // <-- centralizado
                    Button(action: {
                        UIPasteboard.general.string = "+351 915122373"
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                    .frame(width: copyWidth, alignment: .center)
                    .padding(.trailing, 2)
                }
            }
            // Remove Spacer here, add small padding to Close row
            HStack(alignment: .center, spacing: 0) {
                Spacer().frame(width: iconWidth)
                Spacer().frame(minWidth: 140)
                Button(action: { isPresented = false }) {
                    Text("Close")
                        .fontWeight(.regular)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
            }
            .padding(.top, 16) // Add small gap above Close row
            Spacer()
        }
        .padding()
        .frame(maxWidth: 400)
    }
}

struct GridRowView: View {
    let icon: String
    let text: String
    let copyText: String
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: icon)
                .frame(width: 40, alignment: .center)
                .foregroundColor(icon == "envelope" ? .blue : .green)
                .font(.system(size: 22))
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .frame(minWidth: 200, alignment: .leading)
            Button(action: {
                UIPasteboard.general.string = copyText
            }) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.gray)
                    .font(.system(size: 22))
            }
            .frame(width: 40, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
