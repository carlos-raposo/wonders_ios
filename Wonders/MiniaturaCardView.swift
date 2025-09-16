import SwiftUI

struct MiniaturaCardView: View {
    let card: MiniaturaCard
    let translation: MiniaturaCardTranslation
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    
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
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(16)
                        .accessibilityLabel("Imagem da miniatura \(translation.titulo)")
                    Circle()
                        .fill(Color.gray.opacity(0.8))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text("\(card.ordem)")
                                .font(.headline)
                                .foregroundColor(.white)
                        )
                        .padding(8)
                        .accessibilityLabel("Número da miniatura: \(card.ordem)")
                }
                if canFavorite {
                    Button(action: {
                        favoritesManager.toggleFavorite(card: card)
                    }) {
                        Image(systemName: favoritesManager.isFavorite(card: card) ? "heart.fill" : "heart")
                            .foregroundColor(favoritesManager.isFavorite(card: card) ? .red : .white)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(8)
                    .accessibilityLabel(favoritesManager.isFavorite(card: card) ? "Remover dos favoritos" : "Adicionar aos favoritos")
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
