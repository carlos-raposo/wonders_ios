import SwiftUI

struct MainTabView: View {
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
        ZStack {
            switch selectedTab {
            case 0:
                VStack(spacing: 0) {
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
                    MiniaturasTabBar(selectedTab: $selectedTab, showMiniaturas: $showMiniaturas)
                }
            case 1:
                VStack {
                    Text("Favorites")
                    Spacer()
                    MiniaturasTabBar(selectedTab: $selectedTab)
                }
            case 2:
                VStack {
                    Text("Search")
                    Spacer()
                    MiniaturasTabBar(selectedTab: $selectedTab)
                }
            case 3:
                VStack(spacing: 0) {
                    SettingsView()
                    MiniaturasTabBar(selectedTab: $selectedTab)
                }
            default:
                EmptyView()
            }
        }
        .onChange(of: selectedTab) { newValue in
            if newValue != 0 {
                showMiniaturas = false
            }
        }
    }
}

// BottomNavigationBar igual ao da Home
struct MiniaturasTabBar: View {
    @Binding var selectedTab: Int
    var showMiniaturas: Binding<Bool>? = nil
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                selectedTab = 0
                showMiniaturas?.wrappedValue = false
            }) {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .foregroundColor(selectedTab == 0 ? .blue : .primary)
            }
            Spacer()
            Button(action: { selectedTab = 1 }) {
                VStack {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
                .foregroundColor(selectedTab == 1 ? .blue : .primary)
            }
            Spacer()
            Button(action: { selectedTab = 2 }) {
                VStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .foregroundColor(selectedTab == 2 ? .blue : .primary)
            }
            Spacer()
            Button(action: { selectedTab = 3 }) {
                VStack {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .foregroundColor(selectedTab == 3 ? .blue : .primary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground).shadow(radius: 2))
    }
}
