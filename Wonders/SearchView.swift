import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var allCards: [MiniaturaCard] = MiniaturaCard.allCards()
    @State private var selectedCard: MiniaturaCard? = nil
    @EnvironmentObject var languageSettings: LanguageSettings

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
        VStack {
            Text(languageSettings.language == "pt" ? "Pesquisar" : "Search")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 12)
            TextField(languageSettings.language == "pt" ? "Pesquisar..." : "Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            if filteredCards.isEmpty {
                Spacer()
                Text(searchText.isEmpty ? (languageSettings.language == "pt" ? "Digite para pesquisar" : "Type to search") : (languageSettings.language == "pt" ? "Nenhum resultado encontrado" : "No results found"))
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List(filteredCards) { card in
                    let translation = card.translations[languageSettings.language] ?? card.translations["en"] ?? card.translations["pt"]
                    Button(action: { selectedCard = card }) {
                        VStack(alignment: .leading) {
                            Text(translation?.titulo ?? "")
                                .font(.headline)
                            if let desc = translation?.shortDescription, !desc.isEmpty {
                                Text(desc)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
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
