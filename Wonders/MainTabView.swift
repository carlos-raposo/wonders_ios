import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var languageSettings: LanguageSettings
    @State private var selectedTab: Int = 0
    @State private var showMiniaturas: Bool = false
    @State private var selectedCategoryIndex: Int? = nil
    
    let categories: [(title: String, color: Color)] = [
        ("Monuments", Color(red: 1.0, green: 0.92, blue: 0.84)),
        ("Nature", Color(red: 0.82, green: 1.0, blue: 0.89)),
        ("Gastronomy", Color(red: 0.91, green: 0.89, blue: 1.0)),
        ("Popular", Color(red: 1.0, green: 0.98, blue: 0.74)),
        ("Churches", Color(red: 0.82, green: 0.97, blue: 1.0)),
        ("Museums", Color(red: 0.95, green: 0.95, blue: 0.96)),
        ("Sintra", Color(red: 0.87, green: 1.0, blue: 0.82)),
        ("Vocabulary", Color(red: 1.0, green: 0.87, blue: 0.92))
    ]
    let imageNames = [
        "monuments", "nature", "gastronomy", "popular", "churches", "museums", "sintra", "vocabulary"
    ]
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
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
                                categories: categories,
                                imageNames: imageNames,
                                columns: columns,
                                showMiniaturas: $showMiniaturas,
                                selectedCategoryIndex: $selectedCategoryIndex,
                                selectedTab: $selectedTab
                            )
                        }
                    }
                case 1:
                    NavigationStack {
                        FavoritesView()
                    }
                case 2:
                    NavigationStack {
                        VStack {
                            Text("Search")
                            Spacer()
                        }
                    }
                case 3:
                    NavigationStack {
                        SettingsView(selectedTab: $selectedTab)
                    }
                default:
                    EmptyView()
                }
            }
            MiniaturasTabBar(selectedTab: $selectedTab, showMiniaturas: $showMiniaturas)
        }
    }
}

// BottomNavigationBar igual ao da Home
struct MiniaturasTabBar: View {
    @Binding var selectedTab: Int
    var showMiniaturas: Binding<Bool>? = nil
    @EnvironmentObject var languageSettings: LanguageSettings
    private let tabTranslations: [String: [String]] = [
        "en": ["Home", "Favorites", "Search", "Settings"],
        "pt": ["Início", "Favoritos", "Pesquisar", "Definições"]
    ]
    private func t(_ idx: Int) -> String {
        let lang = languageSettings.language
        return tabTranslations[lang]?[idx] ?? tabTranslations["en"]![idx]
    }
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                selectedTab = 0
                showMiniaturas?.wrappedValue = false
            }) {
                VStack {
                    Image(systemName: "house.fill")
                    Text(t(0))
                }
                .foregroundColor(selectedTab == 0 ? .blue : .primary)
            }
            Spacer()
            Button(action: { selectedTab = 1 }) {
                VStack {
                    Image(systemName: "heart")
                    Text(t(1))
                }
                .foregroundColor(selectedTab == 1 ? .blue : .primary)
            }
            Spacer()
            Button(action: { selectedTab = 2 }) {
                VStack {
                    Image(systemName: "magnifyingglass")
                    Text(t(2))
                }
                .foregroundColor(selectedTab == 2 ? .blue : .primary)
            }
            Spacer()
            Button(action: { selectedTab = 3 }) {
                VStack {
                    Image(systemName: "gearshape")
                    Text(t(3))
                }
                .foregroundColor(selectedTab == 3 ? .blue : .primary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground).shadow(radius: 2))
    }
}
