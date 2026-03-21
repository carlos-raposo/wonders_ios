import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageSettings: LanguageSettings
    var isEnglish: Bool { languageSettings.language == "en" }
    var isFrench: Bool { languageSettings.language == "fr" }
    var isSpanish: Bool { languageSettings.language == "es" }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(isEnglish ? "Welcome to Wonders!" : isFrench ? "Bienvenue à Wonders!" : isSpanish ? "¡Bienvenido a Wonders!" : "Bem-vindo à Wonders!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)
                    Text(isEnglish ? "Explore the wonders of Lisbon and organize your visit with ease." : isFrench ? "Explorez les merveilles de Lisbonne et organisez votre visite facilement." : isSpanish ? "Explora las maravillas de Lisboa y organiza tu visita con facilidad." : "Explore as maravilhas de Lisboa e organize a sua visita com facilidade.")
                        .font(.body)
                        .foregroundColor(.primary)
                    Divider()
                    Text(isEnglish ? "How to use the app" : isFrench ? "Comment utiliser l'application" : isSpanish ? "Cómo usar la aplicación" : "Como usar a app")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "square.grid.2x2")
                                .font(.title2)
                                .foregroundColor(.purple)
                            Text(isEnglish ? "1. Choose a category on the home screen (Monuments, Nature, Gastronomy, etc.) and see the highlights." : isFrench ? "1. Choisissez une catégorie sur l'écran d'accueil (Monuments, Nature, Gastronomie, etc.) et découvrez les points forts." : isSpanish ? "1. Elija una categoría en la pantalla principal (Monumentos, Naturaleza, Gastronomía, etc.) y vea los puntos destacados." : "1. Escolha uma categoria na tela inicial (Monumentos, Natureza, Gastronomia, etc.) e veja os destaques.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "doc.text.image")
                                .font(.title2)
                                .foregroundColor(.orange)
                            Text(isEnglish ? "2. Tap a card to see details, history, and location." : isFrench ? "2. Touchez une carte pour voir les détails, l'histoire et l'emplacement." : isSpanish ? "2. Toque una tarjeta para ver detalles, historia y ubicación." : "2. Toque num card para ver detalhes, história e localização.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "heart")
                                .font(.title2)
                                .foregroundColor(.red)
                            Text(isEnglish ? "3. Mark favorites by tapping the heart icon. See your personalized list in the Favorites tab." : isFrench ? "3. Marquez vos favoris en touchant l'icône du cœur. Retrouvez votre liste personnalisée dans l'onglet Favoris." : isSpanish ? "3. Marque favoritos tocando el icono de corazón. Vea su lista personalizada en la pestaña Favoritos." : "3. Marque favoritos tocando no ícone de coração. Veja sua lista personalizada na aba Favoritos.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text(isEnglish ? "4. Share your favorites list with friends using the share button." : isFrench ? "4. Partagez votre liste de favoris avec vos amis en utilisant le bouton de partage." : isSpanish ? "4. Comparte tu lista de favoritos con amigos usando el botón de compartir." : "4. Partilhe sua lista de favoritos com amigos usando o botão de partilha.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "map")
                                .font(.title2)
                                .foregroundColor(.green)
                            Text(isEnglish ? "5. See locations on the map and get directions by tapping the markers." : isFrench ? "5. Voir les emplacements sur la carte et obtenir des directions en touchant les marqueurs." : isSpanish ? "5. Vea las ubicaciones en el mapa y obtenga direcciones tocando los marcadores." : "5. Veja as localizações no mapa e obtenha direções tocando nos marcadores.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text(isEnglish ? "6. Use search to quickly find any card by name or description." : isFrench ? "6. Utilisez la recherche pour trouver rapidement une carte par nom ou description." : isSpanish ? "6. Utilice la búsqueda para encontrar rápidamente cualquier tarjeta por nombre o descripción." : "6. Use a pesquisa para encontrar rapidamente qualquer card pelo nome ou descrição.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "person.crop.circle")
                                .font(.title2)
                                .foregroundColor(.pink)
                            Text(isEnglish ? "7. Access your profile to manage your account, language, and dark/light mode." : isFrench ? "7. Accédez à votre profil pour gérer votre compte, la langue et le mode sombre/clair." : isSpanish ? "7. Acceda a su perfil para gestionar su cuenta, idioma y modo oscuro/claro." : "7. Acesse o perfil para gerir sua conta, idioma e modo escuro/claro.")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    Divider()
                    Text(isEnglish ? "Tips" : isFrench ? "Astuces" : isSpanish ? "Consejos" : "Dicas")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 10) {
                        Text(isEnglish ? "• Cards are available in Portuguese and English. Switch language in settings." : isFrench ? "• Les cartes sont disponibles en portugais et en anglais. Changez la langue dans les paramètres." : isSpanish ? "• Las tarjetas están disponibles en portugués e inglés. Cambia el idioma en la configuración." : "• Os cards estão disponíveis em português e inglês. Troque o idioma nas configurações.")
                        Text(isEnglish ? "• Some cards have extra info like history, usage, and pronunciation." : isFrench ? "• Certaines cartes ont des informations supplémentaires comme l'histoire, l'utilisation et la prononciation." : isSpanish ? "• Algunas tarjetas tienen información extra como historia, uso y pronunciación." : "• Alguns cards têm informações extra como história, uso e pronúncia.")
                        Text(isEnglish ? "• The app adapts to dark/light mode for better readability." : isFrench ? "• L'application s'adapte au mode sombre/clair pour une meilleure lisibilité." : isSpanish ? "• La aplicación se adapta al modo oscuro/claro para una melhor legibilidad." : "• O app adapta-se ao modo escuro/claro para melhor leitura.")
                    }
                    Divider()
                    Text(isEnglish ? "Icon guide" : isFrench ? "Guide des icônes" : isSpanish ? "Guía de iconos" : "Guia de ícones")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "heart.fill").foregroundColor(.red)
                            Text(isEnglish ? "Favorite: adds to favorites." : isFrench ? "Favori : ajoute aux favoris." : isSpanish ? "Favorito: añade a favoritos." : "Favorito: adiciona aos favoritos.")
                        }
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up").foregroundColor(.blue)
                            Text(isEnglish ? "Share: shares your favorites list." : isFrench ? "Partager : partage votre liste de favoris." : isSpanish ? "Compartir: comparte tu lista de favoritos." : "Partilha: partilha a lista de favoritos.")
                        }
                        HStack(spacing: 8) {
                            Image(systemName: "map").foregroundColor(.green)
                            Text(isEnglish ? "Map: shows locations on the map." : isFrench ? "Carte : montre les emplacements sur la carte." : isSpanish ? "Mapa: muestra ubicaciones en el mapa." : "Mapa: mostra localizações no mapa.")
                        }
                    }
                    Divider()
                    Text(isEnglish ? "Need help?" : isFrench ? "Besoin d'aide ?" : isSpanish ? "¿Necesitas ayuda?" : "Precisa de ajuda?")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Text(isEnglish ? "Find this tutorial in settings or contact support for more assistance." : isFrench ? "Retrouvez ce tutoriel dans les paramètres ou contactez le support pour plus d'aide." : isSpanish ? "Encuentra este tutorial en la configuración o contacta con soporte para más ayuda." : "Consulte este tutorial nas configurações ou contacte o suporte para mais assistência.")
                        .font(.body)
                        .foregroundColor(.primary)
                    Spacer(minLength: 24)
                    Button(action: { dismiss() }) {
                        Text(isEnglish ? "Close" : isFrench ? "Fermer" : isSpanish ? "Cerrar" : "Fechar")
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
