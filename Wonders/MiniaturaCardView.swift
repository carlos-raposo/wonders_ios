import SwiftUI

struct MiniaturaCardView: View {
    let card: MiniaturaCard
    let translation: MiniaturaCardTranslation
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @AppStorage("isUserLoggedIn") private var isAuthenticated = false
    var onRequireAuth: (() -> Void)? = nil
    
    private var isVocabularyPT: Bool {
        let cat = card.categoria.lowercased().replacingOccurrences(of: "á", with: "a")
        return languageSettings.language == "pt" && (cat == "vocabulário" || cat == "vocabulario" || cat == "vocabulary")
    }
    
    var body: some View {
        let canFavorite = !isVocabularyPT
        let isTablet = UIDevice.current.userInterfaceIdiom == .pad
        
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topLeading) {
                    Color.clear
                        .aspectRatio(16.0 / 10.0, contentMode: .fit)
                        .overlay(
                            Image(card.imagem)
                                .resizable()
                                .scaledToFill()
                        )
                        .clipped()
                        .cornerRadius(16)
                }
                if canFavorite {
                    Button(action: {
                        if isAuthenticated {
                            favoritesManager.toggleFavorite(card: card)
                        } else {
                            onRequireAuth?()
                        }
                    }) {
                        Image(systemName: favoritesManager.isFavorite(card: card) ? "heart.fill" : "heart")
                            .font(.system(size: isTablet ? 28 : 24, weight: .medium, design: .rounded))
                            .foregroundColor(favoritesManager.isFavorite(card: card) ? .red : .white)
                            .padding(isTablet ? 12 : 8)
                    }
                    .padding(8)
                    .accessibilityLabel(favoritesManager.isFavorite(card: card) ? "Remover dos favoritos" : "Adicionar aos favoritos")
                }
            }
        }
        .frame(maxWidth: isTablet ? 750 : .infinity)
        .padding(.horizontal, isTablet ? 8 : 0) // 👈 Alinha perfeitamente com as margens de texto do tablet
    }
}
