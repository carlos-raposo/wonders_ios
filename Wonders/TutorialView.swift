import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageSettings: LanguageSettings
    var isEnglish: Bool { languageSettings.language == "en" }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(isEnglish ? "Welcome to Wonders!" : "Bem-vindo à Wonders!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)
                    Text(isEnglish ? "Explore the wonders of Lisbon and organize your visit with ease." : "Explore as maravilhas de Lisboa e organize a sua visita com facilidade.")
                        .font(.body)
                        .foregroundColor(.primary)
                    Divider()
                    Text(isEnglish ? "How to use the app" : "Como usar a app")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "square.grid.2x2")
                                .font(.title2)
                                .foregroundColor(.purple)
                            Text(isEnglish ? "1. Choose a category on the home screen (Monuments, Nature, Gastronomy, etc.) and see the highlights." : "1. Escolha uma categoria na tela inicial (Monumentos, Natureza, Gastronomia, etc.) e veja os destaques.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "doc.text.image")
                                .font(.title2)
                                .foregroundColor(.orange)
                            Text(isEnglish ? "2. Tap a card to see details, history, and location." : "2. Toque num card para ver detalhes, história e localização.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "heart")
                                .font(.title2)
                                .foregroundColor(.red)
                            Text(isEnglish ? "3. Mark favorites by tapping the heart icon. See your personalized list in the Favorites tab." : "3. Marque favoritos tocando no ícone de coração. Veja sua lista personalizada na aba Favoritos.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text(isEnglish ? "4. Share your favorites list with friends using the share button." : "4. Partilhe sua lista de favoritos com amigos usando o botão de partilha.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "map")
                                .font(.title2)
                                .foregroundColor(.green)
                            Text(isEnglish ? "5. See locations on the map and get directions by tapping the markers." : "5. Veja as localizações no mapa e obtenha direções tocando nos marcadores.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text(isEnglish ? "6. Use search to quickly find any card by name or description." : "6. Use a pesquisa para encontrar rapidamente qualquer card pelo nome ou descrição.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "person.crop.circle")
                                .font(.title2)
                                .foregroundColor(.pink)
                            Text(isEnglish ? "7. Access your profile to manage your account, language, and dark/light mode." : "7. Acesse o perfil para gerir sua conta, idioma e modo escuro/claro.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    Divider()
                    Text(isEnglish ? "Tips" : "Dicas")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 10) {
                        Text(isEnglish ? "• Cards are available in Portuguese and English. Switch language in settings." : "• Os cards estão disponíveis em português e inglês. Troque o idioma nas configurações.")
                        Text(isEnglish ? "• Some cards have extra info like history, usage, and pronunciation." : "• Alguns cards têm informações extra como história, uso e pronúncia.")
                        Text(isEnglish ? "• The app adapts to dark/light mode for better readability." : "• O app adapta-se ao modo escuro/claro para melhor leitura.")
                    }
                    Divider()
                    Text(isEnglish ? "Icon guide" : "Guia de ícones")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "heart.fill").foregroundColor(.red)
                            Text(isEnglish ? "Favorite: adds to favorites." : "Favorito: adiciona aos favoritos.")
                        }
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up").foregroundColor(.blue)
                            Text(isEnglish ? "Share: shares your favorites list." : "Partilha: partilha a lista de favoritos.")
                        }
                        HStack(spacing: 8) {
                            Image(systemName: "map").foregroundColor(.green)
                            Text(isEnglish ? "Map: shows locations on the map." : "Mapa: mostra localizações no mapa.")
                        }
                    }
                    Divider()
                    Text(isEnglish ? "Need help?" : "Precisa de ajuda?")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Text(isEnglish ? "Find this tutorial in settings or contact support for more assistance." : "Consulte este tutorial nas configurações ou contacte o suporte para mais assistência.")
                        .font(.body)
                        .foregroundColor(.primary)
                    Spacer(minLength: 24)
                    Button(action: { dismiss() }) {
                        Text(isEnglish ? "Close" : "Fechar")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }
                .padding()
            }
            .navigationTitle(isEnglish ? "Tutorial" : "Tutorial")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TutorialView()
}
