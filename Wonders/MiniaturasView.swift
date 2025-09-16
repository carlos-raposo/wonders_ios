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
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<categories.count, id: \.self) { idx in
                            Button(action: {
                                withAnimation {
                                    selectedCategory = idx
                                }
                            }) {
                                VStack {
                                    Text(tCategory(categories[idx]))
                                        .fontWeight(selectedCategory == idx ? .bold : .regular)
                                        .foregroundColor(selectedCategory == idx ? .blue : .primary)
                                    if selectedCategory == idx {
                                        Capsule()
                                            .fill(Color.blue)
                                            .frame(height: 3)
                                            .matchedGeometryEffect(id: "underline", in: underline)
                                    } else {
                                        Capsule()
                                            .fill(Color.clear)
                                            .frame(height: 3)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .background(Color(.systemBackground))
            Divider()
            // Swipe lateral entre categorias
            TabView(selection: $selectedCategory) {
                ForEach(0..<categories.count, id: \.self) { idx in
                    MiniaturasCategoryView(category: categories[idx], language: languageSettings.language)
                        .tag(idx)
                        .padding(.top, 8)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

struct MiniaturasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MiniaturasView(categories: [
                "Monuments", "Nature", "Gastronomy", "Popular", "Churches", "Museums", "Sintra", "Vocabulary"
            ], initialCategory: 0, selectedTab: .constant(0), showMiniaturas: .constant(true))
        }
    }
}
