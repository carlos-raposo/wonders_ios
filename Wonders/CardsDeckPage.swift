import SwiftUI

struct CardsDeckPage: View, Identifiable {
    let id = UUID()
    let card: MiniaturaCard
    let language: String
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @State private var showMapSheet = false
    var translation: MiniaturaCardTranslation { card.translations[language] ?? card.translations["en"]! }
    // Helper to build locations for the map
    var mapLocations: [MiniaturaLocation] {
        var locations: [MiniaturaLocation] = []
        if let lat = card.latitude, let lon = card.longitude {
            locations.append(MiniaturaLocation(title: translation.titulo, latitude: lat, longitude: lon, ordem: card.ordem))
        }
        if let extras = card.extraLocations {
            for (lat, lon) in extras {
                locations.append(MiniaturaLocation(title: translation.titulo, latitude: lat, longitude: lon, ordem: card.ordem))
            }
        }
        return locations
    }
    var body: some View {
        let canFavorite = !(language == "pt" && card.categoria == "Vocabulary")
        let canShowMap = card.categoria.normalized != "vocabulary"
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ZStack(alignment: .topTrailing) {
                        Image(card.imagem)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                            .accessibilityLabel("Imagem da miniatura \(translation.titulo)")
                        if canFavorite {
                            Button(action: {
                                favoritesManager.toggleFavorite(card: card)
                            }) {
                                Image(systemName: favoritesManager.isFavorite(card: card) ? "heart.fill" : "heart")
                                    .foregroundColor(favoritesManager.isFavorite(card: card) ? .red : .white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                            }
                            .padding(12)
                            .accessibilityLabel(favoritesManager.isFavorite(card: card) ? "Remover dos favoritos" : "Adicionar aos favoritos")
                        }
                    }
                    Text(translation.titulo)
                        .font(.title)
                        .bold()
                    if let description = translation.description, !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    if let history = translation.history, !history.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Translations.shared.t("history", lang: language))
                                .font(.headline)
                            Text(history)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    if let adress = translation.adress, !adress.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Translations.shared.t("adress", lang: language))
                                .font(.headline)
                            Text(adress)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer(minLength: 48) // ensures space for floating button
                }
                .padding()
                .accessibilityElement(children: .combine)
            }
            if canShowMap {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showMapSheet = true }) {
                            HStack {
                                Image(systemName: "map")
                                Text(language == "pt" ? "Mapa" : "Map")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .shadow(radius: 4)
                        }
                        .accessibilityLabel(language == "pt" ? "Abrir mapa da miniatura" : "Open item map")
                        Spacer()
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .sheet(isPresented: $showMapSheet) {
            MiniaturasMapView(
                locations: mapLocations,
                mapTitle: (language == "pt" ? "Mapa da miniatura: " : "Item map: ") + translation.titulo
            )
        }
    }
}
