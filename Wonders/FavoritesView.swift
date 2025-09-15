import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
    
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
            let horizontalPadding: CGFloat = 6
            let spacing: CGFloat = 10
            let totalSpacing = spacing + horizontalPadding * 2
            let itemWidth = (geometry.size.width - totalSpacing) / 2
            VStack(spacing: 0) {
                Text(languageSettings.language == "pt" ? "Favoritos" : "Favorites")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 12)
                let favoriteCards = getFavoriteCards()
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
                                                    .cornerRadius(18)
                                                Spacer(minLength: 0)
                                            }
                                            .frame(width: itemWidth, height: itemWidth)
                                            VStack {
                                                Spacer()
                                                Text(translation.titulo)
                                                    .font(.system(size: 20, weight: .regular))
                                                    .foregroundColor(.black)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.horizontal, 8)
                                                    .padding(.bottom, 18)
                                                    .shadow(color: Color.white.opacity(0.7), radius: 4, y: 1)
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
                                        .padding(8)
                                        .accessibilityLabel(languageSettings.language == "pt" ? "Remover dos favoritos" : "Remove from favorites")
                                    }
                                }
                            }
                            .padding(.horizontal, horizontalPadding)
                            .padding(.bottom, 32)
                        }
                    }
                }
                Spacer(minLength: 0)
                HStack {
                    Spacer()
                    Button(action: { /* Map action */ }) {
                        HStack {
                            Text(languageSettings.language == "pt" ? "Mapa" : "Map")
                            Image(systemName: "map")
                        }
                        .font(.headline)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(Color(.systemBackground).opacity(0.95))
                        .clipShape(Capsule())
                        .shadow(radius: 4)
                    }
                    .accessibilityLabel(languageSettings.language == "pt" ? "Abrir mapa dos favoritos" : "Open favorites map")
                    Spacer()
                }
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color(.systemBackground))
            .ignoresSafeArea(edges: .bottom)
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
    UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
}
