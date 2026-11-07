import SwiftUI
import MapKit

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showMapSheet = false
    @State private var selectedCard: MiniaturaCard? = nil
    @State private var showShareSheet = false
    
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
            return "vocabulary_en_\(card.id)"
        }
        return card.imagem
    }
    
    var body: some View {
        GeometryReader { geometry in
            let isTablet = UIDevice.current.userInterfaceIdiom == .pad
            let horizontalPadding: CGFloat = isTablet ? 32 : 16
            let spacing: CGFloat = isTablet ? 16 : 12
            
            // 🌟 Cálculo dinâmico do número de colunas com base na largura do ecrã
            let screenWidth = geometry.size.width
            let columnsCount: Int = {
                if screenWidth > 1100 { return 4 }      // Tablets muito grandes / Paisagem
                else if screenWidth > 750 { return 3 }  // Tablets médios
                else if screenWidth > 500 { return 2 }  // Tablets pequenos / iPhone Max em paisagem
                else { return 2 }                       // Telemóveis padrão
            }()
            
            let totalSpacing = spacing * CGFloat(columnsCount - 1)
            let availableWidth = min(screenWidth, 1100) - (horizontalPadding * 2) - totalSpacing // 👈 Adicionado o limite de 1100 igual à Home
            let itemWidth = max(availableWidth / CGFloat(columnsCount), 1)
            
            let columns = Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing), count: columnsCount)
            
            let colorScheme = UITraitCollection.current.userInterfaceStyle == .dark ? ColorScheme.dark : ColorScheme.light
            
            if geometry.size.width.isFinite, geometry.size.width > 0 {
                let favoriteCards = getFavoriteCards()
                let mapLocations: [MiniaturaLocation] = favoriteCards.flatMap { (_, card, _) in
                    card.locations?.map { loc in
                        MiniaturaLocation(title: MiniaturaCard.localizedLocationName(loc.name, lang: languageSettings.language), latitude: loc.latitude, longitude: loc.longitude, ordem: card.ordem)
                    } ?? []
                }
                let mapTitle: String = languageSettings.language == "pt"
                    ? "Mapa de Favoritos"
                    : "Favorites Map"
                
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        Text(languageSettings.language == "pt" ? "Favoritos" : "Favorites")
                            .font(.system(size: isTablet ? 34 : 26, weight: .regular, design: .rounded))
                            .foregroundColor(Color.primary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, isTablet ? 20 : 16)
                            .padding(.bottom, isTablet ? 28 : 20)
                        
                        if favoriteCards.isEmpty {
                            Spacer()
                            Text(languageSettings.language == "pt" ? "Nenhum favorito ainda" : "No favorites yet")
                                .font(.system(size: isTablet ? 22 : 18, weight: .medium, design: .rounded))
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
                                                VStack(alignment: .center, spacing: 10) {
                                                    ZStack(alignment: .topTrailing) {
                                                        // Imagem com cantos arredondados em toda a volta
                                                        Image(imageName(for: card))
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: itemWidth, height: itemWidth)
                                                            .clipped()
                                                            .cornerRadius(16)
                                                        
                                                        // Botão de favorito no canto superior direito
                                                        Button(action: {
                                                            favoritesManager.toggleFavorite(card: card)
                                                        }) {
                                                            Image(systemName: "heart.fill")
                                                                .foregroundColor(.red)
                                                                .font(.system(size: isTablet ? 20 : 16))
                                                                .padding(8)
                                                        }
                                                        .frame(width: 44, height: 44)
                                                        .contentShape(Circle())
                                                        .padding(4)
                                                        .accessibilityLabel(languageSettings.language == "pt" ? "Remover dos favoritos" : "Remove from favorites")
                                                    }
                                                    .frame(width: itemWidth, height: itemWidth)
                                                    
                                                    // Nome do cartão FORA e ABAIXO da imagem
                                                    Text(translation.titulo)
                                                        .font(.system(size: isTablet ? 16 : 14, weight: .medium, design: .rounded))
                                                        .foregroundColor(.primary)
                                                        .multilineTextAlignment(.center)
                                                        .lineLimit(1)
                                                        .frame(width: itemWidth)
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal, horizontalPadding)
                                    .frame(maxWidth: 1100) // 👈 Garante que a grelha não estica para além do limite
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 100)
                                }
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(Color(.systemBackground))
                    .ignoresSafeArea(edges: .bottom)
                    
                    // Botões flutuantes inferiores (Mapa / Partilhar)
                    HStack {
                        Spacer()
                        Button(action: { showMapSheet = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "map")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundColor(.primary)
                                Text(languageSettings.language == "pt" ? "Mapa" : "Map")
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
                        .accessibilityLabel(languageSettings.language == "pt" ? "Abrir mapa dos favoritos" : "Open favorites map")
                        
                        Spacer()
                        
                        Button(action: { showShareSheet = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundColor(.primary)
                                Text(languageSettings.language == "pt" ? "Partilhar" : "Share")
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
                .background(
                    Group {
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            Color.clear.fullScreenCover(item: $selectedCard) { card in
                                CardsDeckPage(card: card, language: languageSettings.language)
                                    .environmentObject(favoritesManager)
                                    .environmentObject(languageSettings)
                                    .environmentObject(purchaseManager)
                            }
                        } else {
                            Color.clear.sheet(item: $selectedCard) { card in
                                CardsDeckPage(card: card, language: languageSettings.language)
                                    .environmentObject(favoritesManager)
                                    .environmentObject(languageSettings)
                                    .environmentObject(purchaseManager)
                            }
                        }
                    }
                )
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

// Helpers
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

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
