import SwiftUI

struct MiniaturasCategoryView: View {
    let category: String
    let language: String
    @State private var showDeckPage: MiniaturaCard? = nil
    @State private var showMapSheet = false
    
    // Slogans por categoria e idioma
    private let slogans: [String: [String: String]] = [
        "en": [
            "Monuments": "History in every stone.",
            "Nature": "Breathe deep, live nature.",
            "Gastronomy": "Flavors that tell stories.",
            "Popular": "Tradition you can feel.",
            "Churches": "Spirituality and art in harmony.",
            "Museums": "The past at your fingertips.",
            "Sintra": "Enchantment among palaces and forests.",
            "Vocabulary": "Words that bring cultures together."
        ],
        "pt": [
            "Monuments": "História em cada pedra.",
            "Nature": "Respire fundo, viva a natureza.",
            "Gastronomy": "Sabores que contam histórias.",
            "Popular": "Tradição que se sente.",
            "Churches": "Espiritualidade e arte em harmonia.",
            "Museums": "O passado ao alcance das mãos.",
            "Sintra": "Encanto entre palácios e florestas.",
            "Vocabulary": "Palavras que aproximam culturas."
        ]
    ]
    
    private func sloganForCategory() -> String {
        let lang = language
        let key = category
        return slogans[lang]?[key] ?? slogans["en"]?[key] ?? ""
    }
    
    // Adiciona função para garantir categoria original
    private func originalCategoryName(for input: String) -> String {
        switch input.lowercased() {
            case "monuments", "monumentos": return "Monumentos"
            case "nature", "natureza": return "Natureza"
            case "gastronomy", "gastronomia": return "Gastronomia"
            case "popular", "populare": return "Popular"
            case "beaches", "praias": return "Praias"
            case "museums", "museus": return "Museus"
            case "parks", "parques": return "Parques"
            case "traditions", "tradições": return "Tradições"
            case "vocabulary": return "Vocabulary"
            default: return input
        }
    }
    
    private func isVocabularyPT() -> Bool {
        let cat = category.lowercased().replacingOccurrences(of: "á", with: "a")
        return language == "pt" && (cat == "vocabulário" || cat == "vocabulario" || cat == "vocabulary")
    }
    
    private func correctVocabularyCategory() -> String {
        if category.lowercased().contains("vocab") {
            return language == "pt" ? "Vocabulário" : "Vocabulary"
        }
        return originalCategoryName(for: category)
    }
    
    var body: some View {
        let debugCategory = correctVocabularyCategory()
        let debugCards = MiniaturaCard.mockCards(for: debugCategory)
        let mapLocations: [MiniaturaLocation] = debugCards.flatMap { card in
            var locations: [MiniaturaLocation] = []
            let t = card.translations[language] ?? card.translations.values.first!
            if let lat = card.latitude, let lon = card.longitude {
                locations.append(MiniaturaLocation(title: t.titulo, latitude: lat, longitude: lon, ordem: card.ordem))
            }
            if let extras = card.extraLocations {
                for (lat, lon) in extras {
                    locations.append(MiniaturaLocation(title: t.titulo, latitude: lat, longitude: lon, ordem: card.ordem))
                }
            }
            return locations
        }
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack {
                    Text(sloganForCategory())
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        .multilineTextAlignment(.center)
                    VStack(spacing: 24) {
                        ForEach(debugCards, id: \.id) { card in
                            let t = card.translations[language] ?? card.translations.values.first!
                            VStack(spacing: 0) {
                                if !isVocabularyPT() {
                                    Button(action: { showDeckPage = card }) {
                                        MiniaturaCardView(card: card, translation: t)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .accessibilityLabel("Miniatura número \(card.ordem): \(t.titulo)")
                                } else {
                                    MiniaturaCardView(card: card, translation: t)
                                }
                                VStack(spacing: 4) {
                                    Text(t.titulo)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                    Text(t.shortDescription)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.horizontal, 8)
                                .padding(.top, 8)
                                .padding(.bottom, 16)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    print("DEBUG: category=\(category), language=\(language), correctCategory=\(debugCategory), cardsCount=\(debugCards.count)")
                }
            }
            if category != "Vocabulary" {
                HStack {
                    Spacer()
                    Button(action: { showMapSheet = true }) {
                        HStack {
                            Image(systemName: "map")
                            Text(Translations.shared.t("map", lang: language))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(radius: 4)
                    }
                    .accessibilityLabel("\(Translations.shared.t("open_map", lang: language)) \(category)")
                    Spacer()
                }
                .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showMapSheet) {
            MiniaturasMapView(locations: mapLocations, mapTitle: Translations.shared.t("map_category_title", lang: language) + ": " + category)
        }
        .sheet(item: $showDeckPage) { card in
            CardsDeckPage(card: card, language: language)
                .presentationDetents([.large])
                .interactiveDismissDisabled(false)
                .presentationDragIndicator(.visible)
        }
    }
}
