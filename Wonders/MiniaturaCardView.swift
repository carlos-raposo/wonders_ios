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
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topLeading) {
                    Image(card.imagem)
                        .resizable()
                        .aspectRatio(4.0/3.0, contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(6)
                        .accessibilityLabel("Imagem da miniatura \(translation.titulo)")
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
                            .font(.system(size: 24)) // <-- Define o tamanho do ícone
                            .foregroundColor(favoritesManager.isFavorite(card: card) ? .red : .white)
                            .padding(8)
                    }
                    .padding(8)
                    .accessibilityLabel(favoritesManager.isFavorite(card: card) ? "Remover dos favoritos" : "Adicionar aos favoritos")
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(0)
        .shadow(radius: 4)
    }
}
