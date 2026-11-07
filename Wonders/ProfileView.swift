import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum ActiveAlert: Identifiable {
    case message(String)
    case auth
    case delete
    
    var id: String {
        switch self {
        case .message: return "message"
        case .auth: return "auth"
        case .delete: return "delete"
        }
    }
}

struct SettingsView: View {
    @AppStorage("isUserLoggedIn") var isUserLoggedIn: Bool = true
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @State private var errorMessage: String?
    @State private var userName: String? = nil
    @State private var isLoadingName = false
    
    // Estados para edição do nome
    @State private var isEditingName = false
    @State private var editedName = ""
    @State private var isSavingName = false
    
    // Estado unificado para os restantes alertas via Enum
    @State private var activeAlert: ActiveAlert? = nil
    @State private var showSignIn = false

    @EnvironmentObject var languageSettings: LanguageSettings
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showLanguageSheet = false
    @State private var showTutorial = false
    @State private var showContact = false
    @State private var showPrivacy = false
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: Int
    @Binding var showLogin: Bool
    var showBackButton: Bool = false

    var user: User? {
        Auth.auth().currentUser
    }
    
    private var fallbackAvatar: some View {
        ZStack {
            Circle()
                .fill(Color(.systemBlue).opacity(0.2))
                .frame(width: 120, height: 120)
            Text(userInitial)
                .font(.system(size: 56, weight: .semibold, design: .rounded))
                .foregroundColor(Color(.systemBlue))
        }
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
            "user": "User",
            "save": "Save",
            "restore_purchases": "Restore Purchases",
            "restore_started": "Restore process started.",
            "auth_required": "Authentication required",
            "auth_message": "Please log in to manage your account.",
            "sign_in": "Sign In",
            "premium_access": "Premium Access",
            "active_until": "Your access is active until: %@"
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
            "user": "Usuário",
            "save": "Guardar",
            "restore_purchases": "Restaurar Compras",
            "restore_started": "Processo de restauro iniciado.",
            "auth_required": "Autenticação necessária",
            "auth_message": "Faça login para gerir a sua conta.",
            "sign_in": "Entrar",
            "premium_access": "Acesso Premium",
            "active_until": "O seu acesso está ativo até: %@"
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
            "user": "Utilisateur",
            "save": "Enregistrer",
            "restore_purchases": "Restaurar les achats",
            "restore_started": "Processus de restauration démarré.",
            "auth_required": "Authentification requise",
            "auth_message": "Veuillez vous connecter pour gérer votre compte.",
            "sign_in": "Se connecter",
            "premium_access": "Accès Premium",
            "active_until": "Votre accès est actif jusqu'au : %@"
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
            "user": "Usuario",
            "save": "Guardar",
            "restore_purchases": "Restaurar Compras",
            "restore_started": "Proceso de restauración iniciado.",
            "auth_required": "Autenticación requerida",
            "auth_message": "Inicia sesión para gestionar tu cuenta.",
            "sign_in": "Iniciar sesión",
            "premium_access": "Acceso Premium",
            "active_until": "Tu acceso está activo hasta: %@"
        ]
    ]
    
    private func t(_ key: String) -> String {
        translations[languageSettings.language]?[key] ?? translations["en"]![key]!
    }

    private func formattedExpirationDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: languageSettings.language)
        return formatter.string(from: date)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    // Botão de voltar (caso aplicável)
                    HStack {
                        if showBackButton {
                            Button(action: {
                                if #available(iOS 15.0, *) {
                                    dismiss()
                                } else {
                                    selectedTab = 0
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.airbnbSettingsLabel)
                                    .foregroundColor(.primary)
                                    .padding(.trailing, 8)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    Spacer(minLength: 10)

                    // Bloco central com largura máxima restrita para otimização em Tablets
                    VStack(spacing: 32) {
                        // Header / Perfil
                        VStack(spacing: 12) {
                            Text(t("account"))
                                .font(.airbnbSectionTitle)
                                .padding(.top, 8)
                            
                            // Avatar
                            ZStack {
                                if let photoURL = user?.photoURL, let url = URL(string: photoURL.absoluteString) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 120, height: 120)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 120)
                                                .clipShape(Circle())
                                        case .failure(_):
                                            fallbackAvatar
                                        @unknown default:
                                            fallbackAvatar
                                        }
                                    }
                                } else {
                                    fallbackAvatar
                                }
                            }
                            
                            // Nome e Edição
                            if isEditingName {
                                HStack(spacing: 8) {
                                    TextField(t("user"), text: $editedName)
                                        .font(.airbnbSettingsLabel)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .frame(maxWidth: 200)
                                    
                                    Button(action: saveUserName) {
                                        if isSavingName {
                                            ProgressView()
                                        } else {
                                            Text(t("save"))
                                                .font(.airbnbSettingsLabel)
                                                .bold()
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    
                                    Button(t("cancel")) {
                                        isEditingName = false
                                    }
                                    .font(.airbnbSettingsLabel)
                                    .foregroundColor(.gray)
                                }
                            } else {
                                HStack(spacing: 6) {
                                    Text(userName ?? user?.displayName ?? t("user"))
                                        .font(.airbnbSettingsLabel)
                                        .foregroundColor(.primary)
                                    
                                    Button(action: {
                                        editedName = userName ?? user?.displayName ?? ""
                                        isEditingName = true
                                    }) {
                                        Image(systemName: "pencil")
                                            .font(.airbnbSettingsLabel)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            // Email
                            Text(user?.email ?? "-")
                                .font(.airbnbSubtitle)
                                .foregroundColor(.secondary)
                        }
                        
                        // Definições
                        VStack(alignment: .leading, spacing: 12) {
                            Text(t("settings"))
                                .font(.airbnbSettingsLabel)
                                .bold()
                                .padding(.leading, 4)
                                .foregroundColor(.primary)
                            CardButton(icon: isDarkMode ? "sun.max.fill" : "moon.fill", text: t(isDarkMode ? "switch_light" : "switch_dark"), isDestructive: false) {
                                isDarkMode.toggle()
                            }
                            CardButton(icon: "globe", text: t("language"), trailing: Text(languageDisplayName).font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 18 : 15, weight: .regular, design: .rounded)).foregroundColor(.gray)) {
                                showLanguageSheet = true
                            }
                        }
                        
                        // Ajuda
                        VStack(alignment: .leading, spacing: 12) {
                            Text(t("help"))
                                .font(.airbnbSettingsLabel)
                                .bold()
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

                                switch languageSettings.language {
                                case "pt":
                                    urlString = "https://app.sevenwonders.pt/pt/apps/lisboasevenwonders/politica-privacidade.html"
                                case "es":
                                    urlString = "https://app.sevenwonders.pt/es/apps/lisboasevenwonders/politica-privacidade.html"
                                case "fr":
                                    urlString = "https://app.sevenwonders.pt/fr/apps/lisboasevenwonders/politique-confidentialite.html"
                                default:
                                    urlString = "https://app.sevenwonders.pt/en/apps/lisbonsevenwonders/privacy-policy.html"
                                }

                                if let url = URL(string: urlString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                        
                        // Conta & Compras
                        VStack(alignment: .leading, spacing: 12) {
                            Text(t("account"))
                                .font(.airbnbSettingsLabel)
                                .bold()
                                .padding(.leading, 4)
                                .foregroundColor(.primary)
                            
                            // Restaurar Compras
                            CardButton(icon: "arrow.triangle.2.circlepath", text: t("restore_purchases"), isDestructive: false) {
                                Task {
                                    await PurchaseManager.shared.restorePurchases()
                                    await MainActor.run {
                                        activeAlert = .message(t("restore_started"))
                                    }
                                }
                            }
                            
                            // Botão dinâmico: Mostra apenas a Validade Premium se o utilizador já tiver o acesso ativo
                            let isPremiumActive = purchaseManager.isPurchased
                            
                            if isPremiumActive {
                                let expirationText = purchaseManager.expirationDate != nil ? formattedExpirationDate(purchaseManager.expirationDate!) : (languageSettings.language == "pt" ? "Ativo" : "Active")
                                
                                CardButton(
                                    icon: "checkmark.seal.fill",
                                    text: t("premium_access"),
                                    trailing: Text(expirationText)
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 16 : 14, weight: .regular, design: .rounded))
                                        .foregroundColor(.secondary),
                                    isDestructive: false
                                ) {
                                    let messageFormat = t("active_until")
                                    activeAlert = .message(String(format: messageFormat, expirationText))
                                }
                            }

                            if isUserLoggedIn {
                                CardButton(icon: "arrowshape.turn.up.left", text: t("logout"), isDestructive: false) {
                                    logout()
                                }
                                CardButton(icon: "trash", text: t("delete_account"), isDestructive: true) {
                                    activeAlert = .delete
                                }
                            } else {
                                CardButton(icon: "person.crop.circle.badge.plus", text: languageSettings.language == "pt" ? "Entrar" : "Login", isDestructive: false) {
                                    showLogin = true
                                }
                            }
                        }
                    }
                    .frame(maxWidth: 550)
                    .padding(.horizontal, 24)

                    Spacer(minLength: 20)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .onAppear(perform: loadUserName)
        .onChange(of: user?.uid) {
            userName = nil
            loadUserName()
        }
        .sheet(isPresented: $showLanguageSheet) {
            LanguagePickerSheet(selectedLanguage: languageSettings.language) { lang in
                languageSettings.language = lang
                showLanguageSheet = false
            }
        }
        .sheet(isPresented: $showSignIn) {
            LoginView(onAuthenticated: { showSignIn = false })
                .environmentObject(languageSettings)
        }
        .fullScreenCover(isPresented: $showTutorial) {
            TutorialView(
                isPremium: PurchaseManager.shared.isPremium,
                isFirstLaunch: false,
                canSkip: true
            )
            .environmentObject(languageSettings)
        }
        .sheet(isPresented: $showContact) {
            ContactSheetView(isPresented: $showContact)
        }
        // Alerta unificado por Enum para as mensagens de estado e autenticação
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .message(let msg):
                return Alert(
                    title: Text(t("account")),
                    message: Text(msg),
                    dismissButton: .default(Text("OK"))
                )
            case .auth:
                return Alert(
                    title: Text(t("auth_required")),
                    message: Text(t("auth_message")),
                    primaryButton: .default(Text(t("sign_in"))) {
                        showSignIn = true
                    },
                    secondaryButton: .cancel(Text("X"))
                )
            case .delete:
                return Alert(
                    title: Text(t("delete_title")),
                    message: Text(t("delete_message")),
                    primaryButton: .destructive(Text(t("delete_confirm"))) {
                        deleteAccount()
                    },
                    secondaryButton: .cancel(Text(t("cancel")))
                )
            }
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
        guard let user = user else {
            isUserLoggedIn = false
            return
        }
        isUserLoggedIn = true
        isLoadingName = true
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            isLoadingName = false
            if let error = error {
                errorMessage = "Error loading name: \(error.localizedDescription)"
            } else if let data = snapshot?.data() {
                if let name = data["name"] as? String {
                    userName = name
                }
                Task {
                    await PurchaseManager.shared.checkUserFirestoreStatus()
                }
            } else {
                userName = nil
            }
        }
    }

    private func saveUserName() {
        guard let user = user, !editedName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isSavingName = true
        let newName = editedName.trimmingCharacters(in: .whitespaces)
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).setData(["name": newName], merge: true) { error in
            isSavingName = false
            if error == nil {
                userName = newName
                isEditingName = false
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            isUserLoggedIn = false
            userName = nil
            Task {
                await PurchaseManager.shared.updatePurchaseStatus()
            }
        } catch {
            errorMessage = "Error logging out: \(error.localizedDescription)"
        }
    }

    private func deleteAccount() {
        guard let user = user else { return }
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).delete { error in
            user.delete { authError in
                if let authError = authError {
                    errorMessage = "Error deleting account: \(authError.localizedDescription)"
                } else {
                    isUserLoggedIn = false
                    Task {
                        await PurchaseManager.shared.updatePurchaseStatus()
                    }
                }
            }
        }
    }
}

// MARK: - Subviews Auxiliares
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
                    .font(.airbnbSettingsLabel)
                    .foregroundColor(isDestructive ? .red : .primary)
                Text(text)
                    .font(.airbnbSettingsLabel)
                    .foregroundColor(isDestructive ? .red : .primary)
                Spacer()
                trailing
                Image(systemName: "chevron.right")
                    .font(.airbnbSubtitle)
                    .foregroundColor(isDestructive ? .red : .gray)
            }
            .padding()
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemBackground))
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
                .font(.airbnbSectionTitle)
                .padding(.top, 16)
            VStack(spacing: 20) {
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "envelope")
                        .foregroundColor(.blue)
                        .font(.airbnbSettingsLabel)
                        .frame(width: iconWidth, alignment: .center)
                        .padding(.leading, 2)
                    Text("lisbonsevenwonders@gmail.com")
                        .font(.airbnbSettingsLabel)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minWidth: 140, maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        UIPasteboard.general.string = "lisbonsevenwonders@gmail.com"
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.gray)
                            .font(.airbnbSettingsLabel)
                    }
                    .frame(width: copyWidth, alignment: .center)
                    .padding(.trailing, 2)
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "phone")
                        .foregroundColor(.green)
                        .font(.airbnbSettingsLabel)
                        .frame(width: iconWidth, alignment: .center)
                        .padding(.leading, 2)
                    Text("+351 915122373")
                        .font(.airbnbSettingsLabel)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minWidth: 140, maxWidth: .infinity, alignment: .center)
                    Button(action: {
                        UIPasteboard.general.string = "+351 915122373"
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.gray)
                            .font(.airbnbSettingsLabel)
                    }
                    .frame(width: copyWidth, alignment: .center)
                    .padding(.trailing, 2)
                }
            }
            
            HStack(alignment: .center, spacing: 0) {
                Spacer().frame(width: iconWidth)
                Spacer().frame(minWidth: 140)
                Button(action: { isPresented = false }) {
                    Text("Close")
                        .font(.airbnbSettingsLabel)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
            }
            .padding(.top, 16)
            Spacer()
        }
        .padding()
        .frame(maxWidth: 400)
    }
}

struct LanguagePickerSheet: View {
    @State var selectedLanguage: String
    var onSelect: (String) -> Void
    let languages = [
        ("en", "English"),
        ("pt", "Português"),
        ("fr", "Français"),
        ("es", "Español")
    ]
    var body: some View {
        NavigationView {
            List(languages, id: \.0) { lang in
                HStack {
                    Text(lang.1)
                        .font(.airbnbSettingsLabel)
                    Spacer()
                    if selectedLanguage == lang.0 {
                        Image(systemName: "checkmark")
                            .font(.airbnbSettingsLabel)
                            .foregroundColor(.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelect(lang.0)
                }
            }
            .navigationTitle("Idioma")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("OK") {
                        onSelect(selectedLanguage)
                    }
                    .font(.airbnbSettingsLabel)
                }
            }
        }
    }
}
