import SwiftUI
import MapKit

struct CardsDeckPage: View, Identifiable {
    let id = UUID()
    let card: MiniaturaCard
    let language: String
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @State private var showMapSheet = false
    @Environment(\.colorScheme) var colorScheme
    var translation: MiniaturaCardTranslation { card.translations[language] ?? card.translations["en"]! }
    // Helper to build locations for the map
    var mapLocations: [MiniaturaLocation] {
        var locations: [MiniaturaLocation] = []
        if let lat = card.latitude, let lon = card.longitude {
            locations.append(MiniaturaLocation(title: translation.titulo, latitude: lat, longitude: lon, ordem: card.ordem))
        }
        if let extras = card.extraLocations {
            for (name, lat, lon) in extras {
                locations.append(MiniaturaLocation(title: name, latitude: lat, longitude: lon, ordem: card.ordem))
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
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    if let description = translation.description, !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    if let history = translation.history, !history.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Translations.shared.t("history", lang: language))
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text(history)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    if let destaques = translation.destaques, !destaques.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(language == "en" ? "Highlights" : "Destaques")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text(destaques)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    if let usage = translation.usage, !usage.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(language == "en" ? "Usage" : "Uso")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text(usage)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    if let pronunciation = translation.pronunciation, !pronunciation.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(language == "en" ? "Pronunciation" : "Pronúncia")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text(pronunciation)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    if let adress = translation.adress, !adress.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Translations.shared.t("adress", lang: language))
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
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
                                    .foregroundColor(.primary)
                                Text(language == "pt" ? "Mapa" : "Map")
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
                        .accessibilityLabel(language == "pt" ? "Abrir mapa da miniatura" : "Open item map")
                        Spacer()
                    }
                    .padding(.bottom, 0)
                }
            }
        }
        .sheet(isPresented: $showMapSheet) {
            // Prepare locations for the selected card
            let allLocations = mapLocations
            // Use custom zoom/center if present, else default
            let zoomSpan = card.zoomSpan != nil ? MKCoordinateSpan(latitudeDelta: card.zoomSpan!.latitudeDelta, longitudeDelta: card.zoomSpan!.longitudeDelta) : MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let customCenter = card.customCenter != nil ? CLLocationCoordinate2D(latitude: card.customCenter!.latitude, longitude: card.customCenter!.longitude) : (allLocations.first?.coordinate ?? CLLocationCoordinate2D(latitude: 38.7223, longitude: -9.1393))
            MiniaturasMapView(
                locations: allLocations,
                mapTitle: translation.titulo,
                showNumbers: true,
                zoomSpan: zoomSpan,
                customCenter: customCenter
            )
        }
    }
}
