import SwiftUI
import MapKit

struct CardsDeckPage: View, Identifiable {
    let id = UUID()
    let card: MiniaturaCard
    let language: String
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @State private var showMapSheet = false
    @AppStorage("isUserLoggedIn") private var isAuthenticated = false
    @State private var showAuthModal = false
    @State private var showSignIn = false
    @Environment(\.colorScheme) var colorScheme
    var translation: MiniaturaCardTranslation { card.translations[language] ?? card.translations["en"]! }
    // Helper to build locations for the map
    var mapLocations: [MiniaturaLocation] {
        var locations: [MiniaturaLocation] = []
        for loc in card.locations ?? [] {
            locations.append(MiniaturaLocation(title: MiniaturaCard.localizedLocationName(loc.name, lang: languageSettings.language), latitude: loc.latitude, longitude: loc.longitude, ordem: card.ordem))
        }
        return locations
    }
    var body: some View {
        let canFavorite = !(language == "pt" && card.categoria == "Vocabulary")
        let canShowMap = card.categoria.normalized != "vocabulary"
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ZStack(alignment: .topTrailing) {
                        Image(card.imagem)
                            .resizable()
                            .aspectRatio(4.0/3.0, contentMode: .fit)
                            .cornerRadius(6)
                            .accessibilityLabel("Imagem da miniatura \(translation.titulo)")
                            .padding(.horizontal, 0)
                        if canFavorite {
                            Button(action: {
                                if isAuthenticated {
                                    favoritesManager.toggleFavorite(card: card)
                                } else {
                                    showAuthModal = true
                                }
                            }) {
                                Image(systemName: favoritesManager.isFavorite(card: card) ? "heart.fill" : "heart")
                                    .font(.system(size: 24)) // <-- Define o tamanho do ícone
                                    .foregroundColor(favoritesManager.isFavorite(card: card) ? .red : .white)
                                    .padding(10)
                                   // .background(Color.black.opacity(0.3))
                                  //  .clipShape(Circle())
                            }
                            .padding(12)
                            .accessibilityLabel(favoritesManager.isFavorite(card: card) ? "Remover dos favoritos" : "Adicionar aos favoritos")
                        }
                    }
                    Group {
                        Text(translation.titulo)
                            .font(.custom("Montserrat", size: 22).weight(.bold))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                        if let description = translation.description, !description.isEmpty {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                        }
                        if let history = translation.history, !history.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Translations.shared.t("history", lang: language))
                                    .font(.custom("Montserrat", size: 24).weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 12)
                                Text(history)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                        }
                        if let destaques = translation.destaques, !destaques.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Translations.shared.t("highlights", lang: language))
                                    .font(.custom("Montserrat", size: 24).weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 12)
                                Text(destaques)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                        }
                        if let usage = translation.usage, !usage.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Translations.shared.t("usage", lang: language))
                                    .font(.custom("Montserrat", size: 24).weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 12)
                                Text(usage)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                        }
                        if let pronunciation = translation.pronunciation, !pronunciation.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Translations.shared.t("pronunciation", lang: language))
                                    .font(.custom("Montserrat", size: 24).weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 12)
                                Text(pronunciation)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                        }
                        if let adress = translation.adress, !adress.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Translations.shared.t("adress", lang: language))
                                    .font(.custom("Montserrat", size: 24).weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 12)
                                Text(adress)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                        }
                    }
                    Spacer(minLength: 48) // ensures space for floating button
                }
                .accessibilityElement(children: .combine)
            }
            .background(Color(.systemBackground))
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
