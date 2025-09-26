import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var allCards: [MiniaturaCard] = MiniaturaCard.allCards()
    @State private var selectedCard: MiniaturaCard? = nil
    @EnvironmentObject var languageSettings: LanguageSettings
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
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemGray6)) // Fundo adaptativo
                    .frame(height: 48)
                    .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                TextField("", text: $searchText)
                    .font(.system(size: 18))
                    .padding(.horizontal, 16)
                    .foregroundColor(placeholderTextColor) // Aplica cor customizada ao texto digitado
                    .accentColor(placeholderTextColor) // Cursor color
                if searchText.isEmpty {
                    HStack {
                        Text(languageSettings.language == "pt" ? "Pesquisar..." : "Search...")
                            .font(.system(size: 18))
                            .foregroundColor(placeholderTextColor)
                            .padding(.horizontal, 16)
                        Spacer()
                    }
                    .allowsHitTesting(false) // Permite clicar no TextField normalmente
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            .padding(.top, 30) // Adiciona padding top entre a caixa de pesquisa e o topo da tela
            if filteredCards.isEmpty {
                Spacer()
                Text(searchText.isEmpty ? (languageSettings.language == "pt" ? "Digite para pesquisar" : "Type to search") : (languageSettings.language == "pt" ? "Nenhum resultado encontrado" : "No results found"))
                    .font(.system(size: 22, weight: .semibold)) // Maior e mais visível
                    .foregroundColor(feedbackTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Spacer()
            } else {
                List(filteredCards) { card in
                    let translation = card.translations[languageSettings.language] ?? card.translations["en"] ?? card.translations["pt"]
                    Button(action: { selectedCard = card }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(translation?.titulo ?? "")
                                .font(.headline)
                                .foregroundColor(.primary)
                            if let desc = translation?.shortDescription, !desc.isEmpty {
                                Text(desc)
                                    .font(.subheadline)
                                    .foregroundColor(feedbackTextColor)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .background(Color(.systemBackground)) // Fundo adaptativo
        .sheet(item: $selectedCard) { card in
            CardsDeckPage(card: card, language: languageSettings.language)
                .presentationDetents([.large])
                .interactiveDismissDisabled(false)
                .presentationDragIndicator(.visible)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(LanguageSettings())
    }
}
