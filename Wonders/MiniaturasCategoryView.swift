import SwiftUI
import MapKit

struct MiniaturasCategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    let category: String
    let language: String
    @State private var showDeckPage: MiniaturaCard? = nil
    @State private var showMapSheet = false
    
    // Slogans por categoria e idioma
    /*
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
            "Vocabulary": "Palavras que são diferentes em Portugal e no Brasil"
        ]
    ]
    
    private func sloganForCategory() -> String {
        let lang = language
        let key = category
        return slogans[lang]?[key] ?? slogans["en"]?[key] ?? ""
    }
    */
    
    // Adiciona função para garantir categoria original
    private func originalCategoryName(for input: String) -> String {
        switch input.lowercased() {
            case "monuments", "monumentos": return "Monumentos"
            case "nature", "natureza": return "Natureza"
            case "gastronomy", "gastronomia": return "Gastronomia"
            case "popular", "populare": return "Popular"
            case "museums", "museus": return "Museus"
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
    
    // Custom zoom per category
    private func zoomSpanForCategory(_ category: String) -> MKCoordinateSpan {
        let normalized = category.normalized
        switch normalized {
        case "monumentos", "monuments":
            return MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75)
        case "natureza", "nature":
            return MKCoordinateSpan(latitudeDelta: 0.99, longitudeDelta: 0.99)
        case "gastronomia", "gastronomy":
            return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        case "popular":
            return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        case "igrejas", "churches":
            return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        case "museus", "museums":
            return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        case "sintra":
            return MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        case "vocabulário", "vocabulario", "vocabulary":
            return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        default:
            return MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
        }
    }

    // Custom center per category
    private func centerForCategory(_ category: String) -> CLLocationCoordinate2D? {
        let normalized = category.normalized
        switch normalized {
        case "monumentos", "monuments":
            return CLLocationCoordinate2D(latitude: 38.760144, longitude: -9.236019) // Amadora
        case "natureza", "nature":
            return CLLocationCoordinate2D(latitude: 39.091149, longitude: -9.258869) // Torres Vedras
        case "gastronomia", "gastronomy":
            return CLLocationCoordinate2D(latitude: 38.720843, longitude: -9.192982) // Monsanto
        case "popular":
            return CLLocationCoordinate2D(latitude: 38.725268, longitude: -9.150002) // Marques de Pombal
        case "igrejas", "churches":
            return CLLocationCoordinate2D(latitude: 38.7074, longitude: -9.160447) // Basilica da Estrela
        case "museus", "museums":
            return CLLocationCoordinate2D(latitude: 38.7231, longitude: -9.1702) // Museu Arte Antiga
        case "sintra":
            return CLLocationCoordinate2D(latitude: 38.777640, longitude: -9.425583) // Parque Sintra Cascais
        case "vocabulário", "vocabulario", "vocabulary":
            return nil // Sem centro definido
        default:
            return nil
        }
    }
    
    // Helper to get canonical category key for translation
    private func canonicalCategoryKey(_ input: String) -> String {
        switch input.lowercased() {
            case "monuments", "monumentos": return "Monuments"
            case "nature", "natureza": return "Nature"
            case "gastronomy", "gastronomia": return "Gastronomy"
            case "popular": return "Popular"
            case "churches", "igrejas": return "Churches"
            case "museums", "museus": return "Museums"
            case "sintra": return "Sintra"
            case "vocabulary", "vocabulário", "vocabulario": return "Vocabulary"
            default: return input
        }
    }
    
    var body: some View {
        // Use production data source and filter by category
        let cards = MiniaturaCard.allCards().filter { $0.categoria.normalized == correctVocabularyCategory().normalized }
        let mapLocations: [MiniaturaLocation] = cards.flatMap { card in
            card.locations?.map { loc in
                MiniaturaLocation(title: loc.name, latitude: loc.latitude, longitude: loc.longitude, ordem: card.ordem)
            } ?? []
        }
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack {
                    /*Text(sloganForCategory())
                        .font(.title2)
                        .fontWeight(.regular)
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                        .multilineTextAlignment(.center)*/
                    VStack(spacing: 8) {
                        ForEach(cards, id: \.id) { card in
                            let t = card.translations[language] ?? card.translations.values.first!
                            VStack(spacing: 0) {
                                if !isVocabularyPT() {
                                    Button(action: { showDeckPage = card }) {
                                        MiniaturaCardView(card: card, translation: t)
                                            .contentShape(Rectangle()) // Ensure full area is tappable
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .accessibilityLabel("Miniatura número \(card.ordem): \(t.titulo)")
                                } else {
                                    MiniaturaCardView(card: card, translation: t)
                                }
                                // Replace the HStack with a single Text view using AttributedString for mixed styles
                                Text({
                                    var attributed = AttributedString(t.titulo + ": ")
                                    attributed.font = .system(size: 22, weight: .bold)
                                    attributed.foregroundColor = .primary
                                    var desc = AttributedString(t.shortDescription)
                                    desc.font = .system(size: 20, weight: .regular)
                                    desc.foregroundColor = .secondary
                                    attributed.append(desc)
                                    return attributed
                                }())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 0)
                                .padding(.top, 8)
                                .padding(.bottom, 16)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 46)
                }
            }
            if category != "Vocabulary" {
                HStack {
                    Spacer()
                    Button(action: { showMapSheet = true }) {
                        HStack {
                            Image(systemName: "map")
                                .foregroundColor(.primary)
                            Text(Translations.shared.t("map", lang: language))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.regularMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.primary.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.6 : 0.15), radius: 4)
                    }
                    .accessibilityLabel(Translations.shared.t("open_map", lang: language) + " " + category)
                    Spacer()
                }
                .padding(.bottom, 12)
            }
        }
        .sheet(isPresented: $showMapSheet) {
            MiniaturasMapView(
                locations: mapLocations,
                mapTitle: language == "pt"
                    ? Translations.shared.t("map_category_title", lang: language) + " " + Translations.shared.t(canonicalCategoryKey(category), lang: language)
                    : Translations.shared.t(canonicalCategoryKey(category), lang: language) + " " + Translations.shared.t("map_category_title", lang: language),
                showNumbers: true,
                zoomSpan: zoomSpanForCategory(category),
                customCenter: centerForCategory(category)
            )
        }
        .sheet(item: $showDeckPage) { card in
            CardsDeckPage(card: card, language: language)
                .presentationDetents([.large])
                .interactiveDismissDisabled(false)
                .presentationDragIndicator(.visible)
        }
    }
}
