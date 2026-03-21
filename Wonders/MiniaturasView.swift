import SwiftUI

struct MiniaturasView: View {
    let categories: [String]
    @State private var selectedCategory: Int
    @Namespace private var underline
    @Binding var selectedTab: Int
    @Binding var showMiniaturas: Bool
    @EnvironmentObject var languageSettings: LanguageSettings
    @State private var showSettings = false
    @State private var navigateToSettings = false
    @State private var showAuthModal = false
    @State private var showSignIn = false
    
    // Translation dictionary for category names
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
        _selectedCategory = State(initialValue: initialCategory)
        self._selectedTab = selectedTab
        self._showMiniaturas = showMiniaturas
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom AppBar: Back arrow + categories
            HStack(spacing: 0) {
                Button(action: { showMiniaturas = false }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.trailing, 8)
                        .padding(.leading, 8)
                        .padding(.bottom, 14)
                }
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<categories.count, id: \.self) { idx in
                                Button(action: {
                                    withAnimation {
                                        selectedCategory = idx
                                        scrollProxy.scrollTo(idx, anchor: .center)
                                    }
                                }) {
                                    VStack {
                                        Text(tCategory(categories[idx]))
                                            .fontWeight(selectedCategory == idx ? .bold : .thin)
                                            .foregroundColor(selectedCategory == idx ? .blue : .primary)
                                            .opacity(selectedCategory == idx ? 1.0 : 0.8)
                                        Capsule()
                                            .fill(Color.clear)
                                            .frame(height: 3)
                                    }
                                }
                                .id(idx)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .onAppear {
                        // Center the selected category when view appears
                        scrollProxy.scrollTo(selectedCategory, anchor: .center)
                    }
                    .onChange(of: selectedCategory) { oldValue, newValue in
                        withAnimation {
                            scrollProxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
            .background(Color(.systemBackground))
            Divider()
            // Swipe lateral entre categorias
            TabView(selection: $selectedCategory) {
                ForEach(0..<categories.count, id: \ .self) { idx in
                    MiniaturasCategoryView(
                        category: categories[idx],
                        language: languageSettings.language,
                        onRequireAuth: { showAuthModal = true }
                    )
                        .tag(idx)
                        .padding(.top, 8)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
                LoginView(onAuthenticated: { showSignIn = false })
                    .environmentObject(languageSettings)
            }
        }
    }
}
