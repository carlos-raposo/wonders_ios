import SwiftUI
import MapKit

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @State private var showMapSheet = false
    @State private var selectedCard: MiniaturaCard? = nil
    @State private var showShareSheet = false
    private let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
    
    private func getFavoriteCards() -> [(key: String, card: MiniaturaCard, translation: MiniaturaCardTranslation)] {
        var result: [(String, MiniaturaCard, MiniaturaCardTranslation)] = []
        let allCards = MiniaturaCard.allCards()
        for favKey in favoritesManager.favorites {
            if let id = Int(favKey), let card = allCards.first(where: { $0.id == id }) {
                // Exclude Vocabulary cards when in PT
                if languageSettings.language == "pt" && card.categoria == "Vocabulary" {
                    continue
                }
                let translation = card.translations[languageSettings.language]
                    ?? card.translations["en"]
                    ?? card.translations["pt"]
                    ?? card.translations.values.first
                if let translation = translation {
                    result.append((favKey, card, translation))
                }
            }
        }
        // Sort by global id
        result.sort { $0.1.id < $1.1.id }
        return result
    }
    
    private func imageName(for card: MiniaturaCard) -> String {
        if languageSettings.language == "en" && card.categoria == "Vocabulary" {
            // Use an alternative asset name for Vocabulary cards in EN
            return "vocabulary_en_\(card.id)" // You must have these assets in your catalog
        }
        return card.imagem
    }
    
    var body: some View {
        GeometryReader { geometry in
            @Environment(\.colorScheme) var colorScheme
            let horizontalPadding: CGFloat = 6
            let spacing: CGFloat = 8
            let totalSpacing = spacing + horizontalPadding * 2
            if geometry.size.width.isFinite, geometry.size.width > totalSpacing {
                let itemWidth = max((geometry.size.width - totalSpacing) / 2, 1)
                let columns = [GridItem(.fixed(itemWidth), spacing: spacing), GridItem(.fixed(itemWidth), spacing: spacing)]
                let favoriteCards = getFavoriteCards()
                // Fix: Define mapLocations and mapTitle for use in sheet
                let mapLocations: [MiniaturaLocation] = favoriteCards.compactMap { (_, card, translation) in
                    if let lat = card.latitude, let lon = card.longitude {
                        MiniaturaLocation(title: translation.titulo, latitude: lat, longitude: lon, ordem: card.ordem)
                    } else {
                        nil
                    }
                }
                let mapTitle: String = languageSettings.language == "pt"
                    ? "Mapa de Favoritos"
                    : "Favorites Map"
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        Text(languageSettings.language == "pt" ? "Favoritos" : "Favorites")
                            .font(.system(size: 26, weight: .regular))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 12)
                        if favoriteCards.isEmpty {
                            Spacer()
                            Text(languageSettings.language == "pt" ? "Nenhum favorito ainda" : "No favorites yet")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .padding()
                                .accessibilityLabel(languageSettings.language == "pt" ? "Nenhum favorito ainda" : "No favorites yet")
                            Spacer()
                        } else {
                            ScrollView {
                                VStack(spacing: 0) {
                                    LazyVGrid(columns: columns, spacing: spacing) {
                                        ForEach(favoriteCards, id: \.key) { (favKey, card, translation) in
                                            Button(action: { selectedCard = card }) {
                                                ZStack(alignment: .topTrailing) {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                                            .fill(Color(.systemGray6))
                                                            .frame(width: itemWidth, height: itemWidth)
                                                        VStack(spacing: 0) {
                                                            Image(imageName(for: card))
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: itemWidth, height: itemWidth)
                                                                .clipped()
                                                                .cornerRadius(8)
                                                            Spacer(minLength: 0)
                                                        }
                                                        .frame(width: itemWidth, height: itemWidth)
                                                        VStack {
                                                            Spacer()
                                                            ZStack {
                                                                RoundedRectangle(cornerRadius: 0, style: .continuous)
                                                                    .fill(Color.white.opacity(0.5))
                                                                    .shadow(color: Color.black.opacity(0.15), radius: 6, y: -2)
                                                                Text(translation.titulo)
                                                                    .font(.system(size: 20, weight: .regular))
                                                                    .foregroundColor(.black)
                                                                    .multilineTextAlignment(.center)
                                                                    .padding(.horizontal, 0)
                                                                    .padding(.bottom, 0)
                                                            }
                                                            .frame(height: 24)
                                                            .padding(.horizontal, 0)
                                                            .padding(.bottom, 0)
                                                        }
                                                        .frame(width: itemWidth, height: itemWidth)
                                                    }
                                                    Button(action: {
                                                        favoritesManager.toggleFavorite(card: card)
                                                    }) {
                                                        Image(systemName: "heart.fill")
                                                            .foregroundColor(.red)
                                                            .padding(8)
                                                            .background(Color.white.opacity(0.7))
                                                            .clipShape(Circle())
                                                    }
                                                    .frame(width: 40, height: 40)
                                                    .contentShape(Circle())
                                                    .padding(8)
                                                    .accessibilityLabel(languageSettings.language == "pt" ? "Remover dos favoritos" : "Remove from favorites")
                                                }
                                            }
                                            .frame(width: itemWidth, height: itemWidth)
                                            .contentShape(Rectangle())
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal, horizontalPadding)
                                    .padding(.bottom, 80)
                                }
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(Color(.systemBackground))
                    .ignoresSafeArea(edges: .bottom)
                    HStack {
                        Spacer()
                        Button(action: { showMapSheet = true }) {
                            HStack {
                                Image(systemName: "map")
                                    .foregroundColor(.primary)
                                Text(languageSettings.language == "pt" ? "Mapa" : "Map")
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
                        .accessibilityLabel(languageSettings.language == "pt" ? "Abrir mapa dos favoritos" : "Open favorites map")
                        Spacer()
                        Button(action: { showShareSheet = true }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.primary)
                                Text(languageSettings.language == "pt" ? "Partilhar" : "Share")
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
                        .accessibilityLabel(languageSettings.language == "pt" ? "Partilhar favoritos" : "Share favorites")
                        Spacer()
                    }
                    .padding(.bottom, 12)
                }
                .sheet(isPresented: $showMapSheet) {
                    MiniaturasMapView(
                        locations: mapLocations,
                        mapTitle: mapTitle,
                        showNumbers: false,
                        zoomSpan: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04),
                        customCenter: mapLocations.first?.coordinate
                    )
                }
                .sheet(item: $selectedCard) { card in
                    CardsDeckPage(card: card, language: languageSettings.language)
                        .presentationDetents([.large])
                        .interactiveDismissDisabled(false)
                        .presentationDragIndicator(.visible)
                }
                .sheet(isPresented: $showShareSheet) {
                    let favoritesList = favoriteCards.map { "• " + $0.2.titulo }.joined(separator: "\n")
                    ActivityView(activityItems: [favoritesList])
                }
            } else {
                Color.clear
            }
        }
    }
}

// Helper for corner radius on specific corners
fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Helper for safe area top
fileprivate func safeAreaTop() -> CGFloat {
    // Modern iOS 15+ approach
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene
    return windowScene?.keyWindow?.safeAreaInsets.top ?? 0
}

// Helper for share sheet
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
