import SwiftUI
import MapKit

struct MiniaturasCategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    let category: String
    let language: String
    var onRequireAuth: (() -> Void)? = nil
    
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    @State private var showDeckPage: MiniaturaCard? = nil
    @State private var showMapSheet = false
    
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
    
    private func zoomSpanForCategory(_ category: String) -> MKCoordinateSpan {
        let normalized = category.normalized
        switch normalized {
        case "monumentos", "monuments": return MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75)
        case "natureza", "nature": return MKCoordinateSpan(latitudeDelta: 0.99, longitudeDelta: 0.99)
        case "gastronomy", "gastronomia": return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        case "popular": return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        case "igrejas", "churches": return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        case "museus", "museums": return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        case "sintra": return MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        case "vocabulário", "vocabulario", "vocabulary": return MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
        default: return MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
        }
    }

    private func centerForCategory(_ category: String) -> CLLocationCoordinate2D? {
        let normalized = category.normalized
        switch normalized {
        case "monumentos", "monuments": return CLLocationCoordinate2D(latitude: 38.760144, longitude: -9.236019)
        case "natureza", "nature": return CLLocationCoordinate2D(latitude: 39.091149, longitude: -9.258869)
        case "gastronomy", "gastronomia": return CLLocationCoordinate2D(latitude: 38.720843, longitude: -9.192982)
        case "popular": return CLLocationCoordinate2D(latitude: 38.725268, longitude: -9.150002)
        case "igrejas", "churches": return CLLocationCoordinate2D(latitude: 38.7074, longitude: -9.160447)
        case "museus", "museums": return CLLocationCoordinate2D(latitude: 38.7231, longitude: -9.1702)
        case "sintra": return CLLocationCoordinate2D(latitude: 38.777640, longitude: -9.425583)
        default: return nil
        }
    }
    
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
        let isVocab = correctVocabularyCategory().normalized == "vocabulary"
        let cards = MiniaturaCard.allCards().filter { isVocab ? ($0.categoria.normalized == "vocabulary" || $0.categoria.normalized == "vocabulário") : $0.categoria.normalized == correctVocabularyCategory().normalized }
        let mapLocations: [MiniaturaLocation] = cards.flatMap { card in
            card.locations?.map { loc in
                MiniaturaLocation(
                    title: MiniaturaCard.localizedLocationName(loc.name, lang: language),
                    latitude: loc.latitude,
                    longitude: loc.longitude,
                    ordem: card.ordem
                )
            } ?? []
        }
        
        let isTablet = UIDevice.current.userInterfaceIdiom == .pad

        ZStack(alignment: .bottom) {
            ScrollView {
                VStack {
                    Spacer().frame(height: 12)
                    VStack(spacing: 8) {
                        ForEach(cards, id: \.id) { card in
                            let t = card.translations[language] ?? card.translations.values.first!
                            VStack(spacing: 0) {
                                if !isVocabularyPT() {
                                    Button(action: { showDeckPage = card }) {
                                        MiniaturaCardView(card: card, translation: t, onRequireAuth: onRequireAuth)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .accessibilityLabel("Miniatura número \(card.ordem): \(t.titulo)")
                                } else {
                                    MiniaturaCardView(card: card, translation: t, onRequireAuth: onRequireAuth)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    // Título centrado
                                    Text(t.titulo)
                                        .font(.system(size: isTablet ? 26 : 21, weight: .regular, design: .rounded))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    // Descrição alinhada à esquerda
                                    if !t.shortDescription.isEmpty {
                                        Text(t.shortDescription)
                                            .font(.system(size: isTablet ? 22 : 19, weight: .light, design: .rounded))
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .padding(.horizontal, isTablet ? 8 : 12)
                                .padding(.top, 12)
                                .padding(.bottom, 8)
                            }
                            .frame(maxWidth: isTablet ? 750 : .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, isTablet ? 32 : 12)
                    .padding(.bottom, 24)
                }
            }
            
            if category != "Vocabulary" {
                HStack {
                    Spacer()
                    Button(action: { showMapSheet = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "map")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.primary)
                            Text(Translations.shared.t("map", lang: language))
                                .font(.system(size: 14, weight: .regular, design: .rounded))
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
        .background(
            Group {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Color.clear.fullScreenCover(item: $showDeckPage) { card in
                        CardsDeckPage(card: card, language: language)
                            .environmentObject(favoritesManager)
                            .environmentObject(languageSettings)
                            .environmentObject(purchaseManager)
                    }
                } else {
                    Color.clear.sheet(item: $showDeckPage) { card in
                        CardsDeckPage(card: card, language: language)
                            .environmentObject(favoritesManager)
                            .environmentObject(languageSettings)
                            .environmentObject(purchaseManager)
                    }
                }
            }
        )
    }
}
