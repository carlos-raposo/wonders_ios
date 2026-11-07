import SwiftUI

// MARK: - Helper para Cores Adaptáveis (Light / Dark Mode)
extension Color {
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

private let darkCardBackground = Color(red: 30/255, green: 30/255, blue: 30/255)
// Cor Primária da App (#51A0CE)
private let brandActiveColor = Color(red: 81/255, green: 160/255, blue: 206/255)

struct MainTabView: View {
    @EnvironmentObject var languageSettings: LanguageSettings
    @AppStorage("isUserLoggedIn") private var isAuthenticated = false
    @Binding var selectedTab: Int
    @Binding var showLogin: Bool
    var onAuthenticated: () -> Void
    @State private var showMiniaturas: Bool = false
    @State private var selectedCategoryIndex: Int? = nil
    
    // MARK: - Array de Categorias com Fundo e Texto/Ícone Adaptáveis
    let categories: [(title: String, backgroundColor: Color, foregroundColor: Color)] = [
        (
            title: "Monuments",
            backgroundColor: .adaptive(light: Color(red: 255/255, green: 228/255, blue: 142/255), dark: darkCardBackground),
            foregroundColor: .adaptive(light: .black, dark: Color(red: 255/255, green: 228/255, blue: 142/255))
        ),
        (
            title: "Nature",
            backgroundColor: .adaptive(light: Color(red: 192/255, green: 255/255, blue: 195/255), dark: darkCardBackground),
            foregroundColor: .adaptive(light: .black, dark: Color(red: 192/255, green: 255/255, blue: 195/255))
        ),
        (
            title: "Gastronomy",
            backgroundColor: .adaptive(light: Color(red: 198/255, green: 229/255, blue: 255/255), dark: darkCardBackground),
            foregroundColor: .adaptive(light: .black, dark: Color(red: 198/255, green: 229/255, blue: 255/255))
        ),
        (
            title: "Popular",
            backgroundColor: .adaptive(light: Color(red: 255/255, green: 189/255, blue: 168/255), dark: darkCardBackground),
            foregroundColor: .adaptive(light: .black, dark: Color(red: 253/255, green: 193/255, blue: 175/255))
        ),
        (
            title: "Churches",
            backgroundColor: .adaptive(light: Color(red: 255/255, green: 225/255, blue: 235/255), dark: darkCardBackground),
            foregroundColor: .adaptive(light: .black, dark: Color(red: 255/255, green: 225/255, blue: 235/255))
        ),
        (
            title: "Museums",
            backgroundColor: .adaptive(light: Color(red: 189/255, green: 255/255, blue: 246/255), dark: darkCardBackground),
            foregroundColor: .adaptive(light: .black, dark: Color(red: 189/255, green: 255/255, blue: 246/255))
        ),
        (
            title: "Sintra",
            backgroundColor: .adaptive(light: Color(red: 238/255, green: 229/255, blue: 255/255), dark: darkCardBackground),
            foregroundColor: .adaptive(light: .black, dark: Color(red: 212/255, green: 193/255, blue: 252/255))
        ),
        (
            title: "Vocabulary",
            backgroundColor: .adaptive(light: Color(red: 251/255, green: 255/255, blue: 187/255), dark: darkCardBackground),
            foregroundColor: .adaptive(light: .black, dark: Color(red: 249/255, green: 253/255, blue: 190/255))
        )
    ]
    
    let imageNames = [
        "monuments", "nature", "gastronomy", "popular", "churches", "museums", "sintra", "vocabulary"
    ]
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case 0:
                    NavigationStack {
                        if showMiniaturas, let idx = selectedCategoryIndex {
                            MiniaturasView(
                                categories: categories.map { $0.title },
                                initialCategory: idx,
                                selectedTab: $selectedTab,
                                showMiniaturas: $showMiniaturas
                            )
                        } else {
                            HomeView(
                                showMiniaturas: $showMiniaturas,
                                selectedCategoryIndex: $selectedCategoryIndex,
                                selectedTab: $selectedTab
                            )
                        }
                    }
                case 1:
                    NavigationStack {
                        if isAuthenticated {
                            FavoritesView()
                        } else {
                            VStack {
                                Spacer()
                                VStack(spacing: 16) {
                                    Text(languageSettings.language == "pt" ? "Faça login para acessar os favoritos" : "Log in to access favorites")
                                        .font(.title3)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    Button(action: { showLogin = true }) {
                                        Text(languageSettings.language == "pt" ? "Entrar" : "Login")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(brandActiveColor)
                                            .foregroundColor(.white)
                                            .cornerRadius(16)
                                    }
                                    .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 440 : .infinity)
                                    .padding(.horizontal)
                                }
                                Spacer()
                            }
                        }
                    }
                case 2:
                    NavigationStack {
                        SearchView()
                    }
                case 3:
                    NavigationStack {
                        SettingsView(selectedTab: $selectedTab, showLogin: $showLogin)
                    }
                default:
                    EmptyView()
                }
            }
            MiniaturasTabBar(selectedTab: $selectedTab, showMiniaturas: $showMiniaturas)
        }
    }
}

// MARK: - BottomNavigationBar
struct MiniaturasTabBar: View {
    @Binding var selectedTab: Int
    var showMiniaturas: Binding<Bool>? = nil
    @EnvironmentObject var languageSettings: LanguageSettings
    
    // Cor azul personalizada para o item selecionado (#51A0CE)
    private let activeColor = Color(red: 81/255, green: 160/255, blue: 206/255)
    
    private let tabTranslations: [String: [String]] = [
        "en": ["Home", "Favorites", "Search", "Settings"],
        "pt": ["Início", "Favoritos", "Pesquisar", "Definições"],
        "fr": ["Accueil", "Favoris", "Recherche", "Paramètres"],
        "es": ["Inicio", "Favoritos", "Buscar", "Configuración"]
    ]
    
    private func t(_ idx: Int) -> String {
        let lang = languageSettings.language
        return tabTranslations[lang]?[idx] ?? tabTranslations["en"]![idx]
    }
    
    var body: some View {
        HStack {
            Spacer()
            // Tab 0: Home / Início
            Button(action: {
                selectedTab = 0
                showMiniaturas?.wrappedValue = false
            }) {
                VStack {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .font(.system(size: 24, weight: .light))
                        .opacity(selectedTab == 0 ? 1.0 : 0.7)
                    Text(t(0))
                        .font(.system(size: 14, weight: .light))
                        .opacity(selectedTab == 0 ? 1.0 : 0.7)
                }
                .foregroundColor(selectedTab == 0 ? activeColor : .primary)
            }
            Spacer()
            // Tab 1: Favorites / Favoritos
            Button(action: { selectedTab = 1 }) {
                VStack {
                    Image(systemName: selectedTab == 1 ? "heart.fill" : "heart")
                        .font(.system(size: 24, weight: .light))
                        .opacity(selectedTab == 1 ? 1.0 : 0.7)
                    Text(t(1))
                        .font(.system(size: 14, weight: .light))
                        .opacity(selectedTab == 1 ? 1.0 : 0.7)
                }
                .foregroundColor(selectedTab == 1 ? activeColor : .primary)
            }
            Spacer()
            // Tab 2: Search / Pesquisar
            Button(action: { selectedTab = 2 }) {
                VStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24, weight: selectedTab == 2 ? .semibold : .light))
                        .opacity(selectedTab == 2 ? 1.0 : 0.7)
                    Text(t(2))
                        .font(.system(size: 14, weight: .light))
                        .opacity(selectedTab == 2 ? 1.0 : 0.7)
                }
                .foregroundColor(selectedTab == 2 ? activeColor : .primary)
            }
            Spacer()
            // Tab 3: Settings / Definições
            Button(action: { selectedTab = 3 }) {
                VStack {
                    Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                        .font(.system(size: 24, weight: .light))
                        .opacity(selectedTab == 3 ? 1.0 : 0.7)
                    Text(t(3))
                        .font(.system(size: 14, weight: .light))
                        .opacity(selectedTab == 3 ? 1.0 : 0.7)
                }
                .foregroundColor(selectedTab == 3 ? activeColor : .primary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground).shadow(radius: 2))
    }
}
