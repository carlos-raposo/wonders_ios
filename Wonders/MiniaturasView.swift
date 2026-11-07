import SwiftUI

struct MiniaturasView: View {
    let categories: [String]
    let initialCategory: Int
    @Binding var selectedTab: Int
    @Binding var showMiniaturas: Bool
    
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @AppStorage("isUserLoggedIn") private var isAuthenticated = false
    
    @State private var showAuthModal = false
    @State private var showSignIn = false
    
    private let categoryTranslations: [String: [String: String]] = [
        "en": [
            "Monuments": "Monuments",
            "Nature": "Nature",
            "Gastronomy": "Gastronomy",
            "Popular": "Popular",
            "Churches": "Churches",
            "Museums": "Museums",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulary"
        ],
        "pt": [
            "Monuments": "Monumentos",
            "Nature": "Natureza",
            "Gastronomy": "Gastronomia",
            "Popular": "Popular",
            "Churches": "Igrejas",
            "Museums": "Museus",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulário"
        ],
        "es": [
            "Monuments": "Monumentos",
            "Nature": "Naturaleza",
            "Gastronomy": "Gastronomía",
            "Popular": "Popular",
            "Churches": "Iglesias",
            "Museums": "Museos",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulario"
        ],
        "fr": [
            "Monuments": "Monuments",
            "Nature": "Nature",
            "Gastronomy": "Gastronomie",
            "Popular": "Populaire",
            "Churches": "Églises",
            "Museums": "Musées",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulaire"
        ]
    ]
    
    private func tCategory(_ key: String) -> String {
        categoryTranslations[languageSettings.language]?[key] ?? key
    }
    
    init(categories: [String], initialCategory: Int, selectedTab: Binding<Int>, showMiniaturas: Binding<Bool>) {
        self.categories = categories
        self.initialCategory = initialCategory
        self._selectedTab = selectedTab
        self._showMiniaturas = showMiniaturas
    }
    
    var body: some View {
        let isTablet = UIDevice.current.userInterfaceIdiom == .pad
        
        VStack(spacing: 0) {
            // 🌟 CABEÇALHO UNIFICADO IDÊNTICO AO CARDSDECKPAGE
            ZStack {
                HStack {
                    Button(action: { showMiniaturas = false }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                    }
                    .accessibilityLabel(languageSettings.language == "pt" ? "Voltar" : "Back")
                    
                    Spacer()
                }
                
                let currentCategory = categories[initialCategory]
                
                Text(tCategory(currentCategory))
                    .font(.system(size: isTablet ? 26 : 24, weight: .regular, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 60)
                
                HStack {
                    Spacer()
                    Color.clear
                        .frame(width: 44, height: 44)
                        .padding(.horizontal, 16)
                }
            }
            .frame(height: 40)
            .background(Color(.systemBackground))
            
            
            // Renderização direta da categoria selecionada
            MiniaturasCategoryView(
                category: categories[initialCategory],
                language: languageSettings.language,
                onRequireAuth: { showAuthModal = true }
            )
            
            
            Spacer(minLength: 0)
        }
        .alert(isPresented: $showAuthModal) {
            Alert(
                title: Text(languageSettings.language == "pt" ? "Autenticação necessária" : "Authentication required"),
                message: Text(languageSettings.language == "pt" ? "Faça login para adicionar favoritos." : "Please log in to add favorites."),
                primaryButton: .default(Text(languageSettings.language == "pt" ? "Entrar" : "Sign In")) {
                    showSignIn = true
                },
                secondaryButton: .cancel(Text("X"))
            )
        }
        .sheet(isPresented: $showSignIn) {
            LoginView(onAuthenticated: {
                isAuthenticated = true
                favoritesManager.refreshFavorites()
                showSignIn = false
            })
            .environmentObject(favoritesManager)
            .environmentObject(languageSettings)
        }
    }
}
