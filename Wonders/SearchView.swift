import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var allCards: [MiniaturaCard] = MiniaturaCard.allCards()
    @State private var selectedCard: MiniaturaCard? = nil
    @EnvironmentObject var languageSettings: LanguageSettings
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.colorScheme) var colorScheme // Detect dark/light mode

    // Custom colors for feedback/placeholder text
    var feedbackTextColor: Color {
        colorScheme == .dark ? Color(white: 0.85) : Color(white: 0.35)
    }
    var placeholderTextColor: Color {
        colorScheme == .dark ? Color(white: 0.9) : Color(white: 0.25)
    }

    var filteredCards: [MiniaturaCard] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return []
        }
        let query = searchText.normalized
        return allCards.filter { card in
            let translation = card.translations[languageSettings.language] ?? card.translations["en"] ?? card.translations["pt"]
            guard let t = translation else { return false }
            return t.titulo.normalized.contains(query) ||
                   t.shortDescription.normalized.contains(query) ||
                   (t.description?.normalized.contains(query) ?? false)
        }
    }

    var body: some View {
        let isTablet = UIDevice.current.userInterfaceIdiom == .pad

        VStack(spacing: 0) {
            // 🌟 BARRA DE PESQUISA COM LARGURA CONTROLADA NO IPAD
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemGray6))
                    .frame(height: isTablet ? 54 : 48)
                    .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                
                TextField("", text: $searchText)
                    .font(.system(size: isTablet ? 20 : 18, weight: .regular, design: .rounded))
                    .padding(.horizontal, 16)
                    .foregroundColor(placeholderTextColor)
                    .accentColor(placeholderTextColor)
                    .onSubmit {
                        hideKeyboard()
                    }
                    .submitLabel(.search)
                
                if searchText.isEmpty {
                    HStack {
                        Text(languageSettings.language == "pt" ? "Pesquisar..." : "Search...")
                            .font(.system(size: isTablet ? 20 : 18, weight: .regular, design: .rounded))
                            .foregroundColor(placeholderTextColor)
                            .padding(.horizontal, 16)
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }
            }
            .frame(maxWidth: isTablet ? 750 : .infinity) // 👈 Limita a largura máxima no iPad
            .padding(.horizontal, isTablet ? 32 : 16)
            .padding(.bottom, 16)
            .padding(.top, isTablet ? 24 : 30)

            // 🌟 CONTEÚDO (RESULTADOS OU MENSAGEM DE FEEDBACK)
            if filteredCards.isEmpty {
                Spacer()
                Text(searchText.isEmpty ? (languageSettings.language == "pt" ? "Digite para pesquisar" : "Type to search") : (languageSettings.language == "pt" ? "Nenhum resultado encontrado" : "No results found"))
                    .font(.system(size: isTablet ? 24 : 22, weight: .semibold, design: .rounded))
                    .foregroundColor(feedbackTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Spacer()
            } else {
                List(filteredCards) { card in
                    let translation = card.translations[languageSettings.language] ?? card.translations["en"] ?? card.translations["pt"]
                    Button(action: { selectedCard = card }) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(translation?.titulo ?? "")
                                .font(.system(size: isTablet ? 20 : 17, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            if let desc = translation?.shortDescription, !desc.isEmpty {
                                Text(desc)
                                    .font(.system(size: isTablet ? 17 : 15, weight: .light, design: .rounded))
                                    .foregroundColor(feedbackTextColor)
                            }
                        }
                        .padding(.vertical, isTablet ? 8 : 6)
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxWidth: isTablet ? 750 : .infinity) // 👈 Centraliza e limita a largura da lista no iPad
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color(.systemBackground))
        .fullScreenCover(item: $selectedCard) { card in
            CardsDeckPage(card: card, language: languageSettings.language)
                .environmentObject(languageSettings)
                .environmentObject(favoritesManager)
                .environmentObject(purchaseManager)
        }
    }
}

// Helper para esconder o teclado
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
