import SwiftUI
import FirebaseAuth

// Estrutura para configurar cada indicador individual com coordenadas relativas (0.0 a 1.0)
struct IndicatorConfig {
    let x: CGFloat // Percentagem da largura (0.0 = esquerda, 1.0 = direita)
    let y: CGFloat // Percentagem da altura (0.0 = topo, 1.0 = fundo)
    let size: CGFloat
    let color: Color
}

struct TutorialPageItem: Identifiable {
    let id = UUID()
    let imageName: String?
    let titleKey: String
    let descriptionKey: String
    let indicators: [IndicatorConfig]
}

struct TutorialDictionary {
    
    static let pt: [String: String] = [
        "L10n_tutorialSlide1Title": "GUIA RÁPIDO",
        "L10n_tutorialSlide1Description": "Descubra locais e experiências organizados por categorias\nAceda a informações detalhadas\nOuça os áudio-guias (funcionalidade PREMIUM)\nOriente-se com mapas interativos\nCrie e partilhe os seus itinerários personalizados\nEste guia rápido leva menos de 1 minuto e dá-lhe tudo o que precisa para começar.",
        
        "L10n_tutorialSlide2Title": "Explore por categorias",
        "L10n_tutorialSlide2Description": "Toque no ***ícone Início*** na barra de navegação para navegar por temas ou tópicos.",
        
        "L10n_tutorialSlide3Title": "Mais informações",
        "L10n_tutorialSlide3Description": "Toque em qualquer imagem para descobrir a sua história. (***Conteúdo alargado na versão PREMIUM***)",
        
        "L10n_tutorialSlide4Title": "Áudio-guia",
        "L10n_tutorialSlide4Description": "Toque no ***botão Reproduzir*** para ouvir o áudio-guia completo de cada local ou experiência. (***Funcionalidade PREMIUM***)",
        
        "L10n_tutorialSlide5Title": "Navegação no mapa",
        "L10n_tutorialSlide5Description": "Toque no ***ícone Mapa*** para ver a localização exata de cada ponto.",
        
        "L10n_tutorialSlide6Title": "Guardar no itinerário",
        "L10n_tutorialSlide6Description": "Toque no ***ícone Coração*** numa imagem para adicionar ou remover esse local ou experiência da sua lista.",
        
        "L10n_tutorialSlide7Title": "O seu itinerário personalizado",
        "L10n_tutorialSlide7Description": "Aceda aos seus locais guardados e ao seu itinerário usando o ***ícone Favoritos (Coração)*** na barra de navegação.",
        
        "L10n_tutorialSlide8Title": "Partilhe a experiência",
        "L10n_tutorialSlide8Description": "Use o ***ícone Partilhar*** na página dos Favoritos para enviar o seu itinerário a amigos e familiares.",
        
        "L10n_tutorialSlide9Title": "Pesquisa rápida",
        "L10n_tutorialSlide9Description": "Encontre qualquer ponto de interesse tocando no ***ícone Pesquisar (Lupa)*** na barra de navegação.",
        
        "L10n_tutorialSlide10Title": "Definições",
        "L10n_tutorialSlide10Description": "Toque no ***ícone Engrenagem*** na barra de navegação para aceder às definições, mudar de idioma ou alternar entre o modo Claro e Escuro.",
        
        "L10n_tutorialSlide11Title": "Tudo pronto!",
        "L10n_tutorialSlide11Description": "Parabéns por concluir o guia! Tem agora tudo o que precisa para explorar Lisboa. Se precisar de rever este guia, aceda às Definições a qualquer momento.",
        
        "L10n_tutorialButtonPrev": "Anterior",
        "L10n_tutorialButtonNext": "Seguinte",
        "L10n_tutorialButtonSkip": "Saltar",
        "L10n_tutorialButtonStart": "Começar",
        
        "L10n_tutorialSkipDialogTitle": "Saltar o guia?",
        "L10n_tutorialSkipDialogMessage": "Este guia rápido leva menos de 1 minuto e dá-lhe tudo o que precisa para começar. Pode também revê-lo a qualquer momento nas Definições.",
        "L10n_tutorialSkipDialogLater": "Eu faço isso depois",
        "L10n_tutorialSkipDialogNow": "Eu faço isso agora"
    ]
    
    static let en: [String: String] = [
        "L10n_tutorialSlide1Title": "QUICK GUIDE",
        "L10n_tutorialSlide1Description": "Discover places and experiences organized by categories\nAccess detailed information\nListen to audio guides (PREMIUM feature)\nGet oriented with interactive maps\nCreate and share your custom itineraries\nThis quick guide takes less than 1 minute and gives you everything you need to start.",
        
        "L10n_tutorialSlide2Title": "Explore by categories",
        "L10n_tutorialSlide2Description": "Tap the ***Home icon*** on the navigation bar to browse by themes or topics.",
        
        "L10n_tutorialSlide3Title": "More information",
        "L10n_tutorialSlide3Description": "Tap any image to discover its history. (***Extended content in PREMIUM version***)",
        
        "L10n_tutorialSlide4Title": "Audio guide",
        "L10n_tutorialSlide4Description": "Tap the ***Play button*** to listen to the full audio guide for each place or experience. (***PREMIUM feature***)",
        
        "L10n_tutorialSlide5Title": "Map navigation",
        "L10n_tutorialSlide5Description": "Tap the ***Map icon*** to see the exact location of each point.",
        
        "L10n_tutorialSlide6Title": "Save to itinerary",
        "L10n_tutorialSlide6Description": "Tap the ***Heart icon*** on an image to add or remove that place or experience from your list.",
        
        "L10n_tutorialSlide7Title": "Your custom itinerary",
        "L10n_tutorialSlide7Description": "Access your saved places and itinerary using the ***Favorites icon (Heart)*** on the navigation bar.",
        
        "L10n_tutorialSlide8Title": "Share the experience",
        "L10n_tutorialSlide8Description": "Use the ***Share icon*** on the Favorites page to send your itinerary to friends and family.",
        
        "L10n_tutorialSlide9Title": "Quick search",
        "L10n_tutorialSlide9Description": "Find any point of interest by tapping the ***Search icon (Magnifying Glass)*** on the navigation bar.",
        
        "L10n_tutorialSlide10Title": "Settings",
        "L10n_tutorialSlide10Description": "Tap the ***Gear icon*** on the navigation bar to access settings, switch languages, or toggle between Light and Dark mode.",
        
        "L10n_tutorialSlide11Title": "All set!",
        "L10n_tutorialSlide11Description": "Congratulations on completing the guide! You now have everything you need to explore Lisbon. If you need to review these tips, access Settings at any time.",
        
        "L10n_tutorialButtonPrev": "Previous",
        "L10n_tutorialButtonNext": "Next",
        "L10n_tutorialButtonSkip": "Skip",
        "L10n_tutorialButtonStart": "Get Started",
        
        "L10n_tutorialSkipDialogTitle": "Skip the guide?",
        "L10n_tutorialSkipDialogMessage": "This quick guide takes less than 1 minute and gives you everything you need to start. You can also review it at any time in Settings.",
        "L10n_tutorialSkipDialogLater": "I'll do it later",
        "L10n_tutorialSkipDialogNow": "I'll do it now"
    ]
    
    static let es: [String: String] = [
        "L10n_tutorialSlide1Title": "GUÍA RÁPIDA",
        "L10n_tutorialSlide1Description": "Descubra lugares y experiencias organizados por categorías\nAcceda a información detallada\nEscuche las audioguías (función PREMIUM)\nOriéntese con mapas interactivos\nCree y comparta sus itinerarios personalizados\nEsta guía rápida requiere menos de 1 minuto y le ofrece todo lo necesario para comenzar.",
        
        "L10n_tutorialSlide2Title": "Explore por categorías",
        "L10n_tutorialSlide2Description": "Toque el ***icono Inicio*** en la barra de navegación para explorar por temas o tópicos.",
        
        "L10n_tutorialSlide3Title": "Más información",
        "L10n_tutorialSlide3Description": "Toque cualquier imagen para descubrir su historia. (***Contenido ampliado en la versión PREMIUM***)",
        
        "L10n_tutorialSlide4Title": "Audioguía",
        "L10n_tutorialSlide4Description": "Toque el ***botón Reproducir*** para escuchar la audioguía completa de cada lugar o experiencia. (***Función PREMIUM***)",
        
        "L10n_tutorialSlide5Title": "Navegación en el mapa",
        "L10n_tutorialSlide5Description": "Toque el ***icono Mapa*** para ver la ubicación exacta de cada punto.",
        
        "L10n_tutorialSlide6Title": "Guardar en el itinerario",
        "L10n_tutorialSlide6Description": "Toque el ***icono Corazón*** en una imagen para añadir o eliminar ese lugar o experiencia de su lista.",
        
        "L10n_tutorialSlide7Title": "Su itinerario personalizado",
        "L10n_tutorialSlide7Description": "Acceda a sus lugares guardados y a su itinerario mediante el ***icono Favoritos (Corazón)*** en la barra de navegación.",
        
        "L10n_tutorialSlide8Title": "Comparta la experiencia",
        "L10n_tutorialSlide8Description": "Utilice el ***icono Compartir*** en la página de Favoritos para enviar su itinerario a amigos y familiares.",
        
        "L10n_tutorialSlide9Title": "Búsqueda rápida",
        "L10n_tutorialSlide9Description": "Encuentre cualquier punto de interés tocando el ***icono Buscar (Lupa)*** en la barra de navegación.",
        
        "L10n_tutorialSlide10Title": "Ajustes",
        "L10n_tutorialSlide10Description": "Toque el ***icono Engranaje*** en la barra de navegación para acceder aos ajustes, cambiar de idioma ou alternar entre el modo Claro y Oscuro.",
        
        "L10n_tutorialSlide11Title": "¡Todo listo!",
        "L10n_tutorialSlide11Description": "¡Enhorabuena por completar la guía! Ya tiene todo lo necesario para explorar Lisboa. Si necesita revisar esta guia, acceda a Ajustes en cualquier momento.",
        
        "L10n_tutorialButtonPrev": "Anterior",
        "L10n_tutorialButtonNext": "Siguiente",
        "L10n_tutorialButtonSkip": "Saltar",
        "L10n_tutorialButtonStart": "Empezar",
        
        "L10n_tutorialSkipDialogTitle": "¿Omitir la guía?",
        "L10n_tutorialSkipDialogMessage": "Esta guía rápida lleva menos de 1 minuto e le ofrece todo lo necesario para comenzar. Puede revisarla en cualquier momento en Ajustes.",
        "L10n_tutorialSkipDialogLater": "Lo haré más tarde",
        "L10n_tutorialSkipDialogNow": "Lo haré ahora"
    ]
    
    static let fr: [String: String] = [
        "L10n_tutorialSlide1Title": "GUIDE RAPIDE",
        "L10n_tutorialSlide1Description": "Découvrez des lieux et expériences organisés par catégories\nAccédez à des informations détaillées\nÉcoutez les audioguides (fonctionnalité PREMIUM)\nOrientez-vous grâce aux cartes interactives\nCréez et partagez vos itinéraires personnalisés\nCe guide rapide prend moins d'une minute et vous donne tout ce dont vous avez besoin pour commencer.",
        
        "L10n_tutorialSlide2Title": "Explorez par catégories",
        "L10n_tutorialSlide2Description": "Appuyez sur l'***icône Accueil*** dans la barre de navigation pour parcourir par thèmes ou sujets.",
        
        "L10n_tutorialSlide3Title": "Plus d'informations",
        "L10n_tutorialSlide3Description": "Appuyez sur n'importe quelle image pour découvrir son histoire. (***Contenu détaillé dans la version PREMIUM***)",
        
        "L10n_tutorialSlide4Title": "Audioguide",
        "L10n_tutorialSlide4Description": "Appuyez sur le ***bouton Lecture*** pour écouter l'audioguide complet de chaque lieu ou expérience. (***Fonctionnalité PREMIUM***)",
        
        "L10n_tutorialSlide5Title": "Navigation sur la carte",
        "L10n_tutorialSlide5Description": "Appuyez sur l'***icône Carte*** pour voir l'emplacement exact de chaque point.",
        
        "L10n_tutorialSlide6Title": "Enregistrer dans l'itinéraire",
        "L10n_tutorialSlide6Description": "Appuyez sur l'***icône Cœur*** sur une image pour ajouter ou retirer ce lieu ou cette expérience de votre liste.",
        
        "L10n_tutorialSlide7Title": "Votre itinéraire personnalisé",
        "L10n_tutorialSlide7Description": "Accédez à vos lieux enregistrés et à votre itinéraire via l'***icône Favoris (Cœur)*** dans la barra de navegação.",
        
        "L10n_tutorialSlide8Title": "Partagez l'expérience",
        "L10n_tutorialSlide8Description": "Utilisez l'***icône Partager*** sur la page des Favoris pour envoyer votre itinéraire à vos amis et à votre famille.",
        
        "L10n_tutorialSlide9Title": "Recherche rápida",
        "L10n_tutorialSlide9Description": "Trouvez n'importe quel point d'intérêt en appuyant sur l'***icône Rechercher (Loupe)*** dans la barra de navegação.",
        
        "L10n_tutorialSlide10Title": "Paramètres",
        "L10n_tutorialSlide10Description": "Appuyez sur l'***icône Engrenagem*** dans la barra de navegação pour accéder aux paramètres, changer de langue ou basculer entre le mode Clair et Sombre.",
        
        "L10n_tutorialSlide11Title": "Tout est prêt !",
        "L10n_tutorialSlide11Description": "Félicitations pour avoir terminé le guide ! Vous avez maintenant tout ce qu'il vous faut pour explorer Lisbonne. Si vous avez besoin de revoir ces conseils, accédez aux Paramètres à tout moment.",
        
        "L10n_tutorialButtonPrev": "Précédent",
        "L10n_tutorialButtonNext": "Suivant",
        "L10n_tutorialButtonSkip": "Passer",
        "L10n_tutorialButtonStart": "Commencer",
        
        "L10n_tutorialSkipDialogTitle": "Passer le guide ?",
        "L10n_tutorialSkipDialogMessage": "Ce guide rapide prend moins d'une minute et vous donne tout ce dont vous avez besoin pour commencer. Vous pouvez le revoir à tout moment dans les Paramètres.",
        "L10n_tutorialSkipDialogLater": "Plus tard",
        "L10n_tutorialSkipDialogNow": "Maintenant"
    ]
    
    static func text(for key: String, lang: String) -> String {
        switch lang.lowercased() {
        case "pt": return pt[key] ?? en[key] ?? key
        case "es": return es[key] ?? en[key] ?? key
        case "fr": return fr[key] ?? en[key] ?? key
        default: return en[key] ?? key
        }
    }
}

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageSettings: LanguageSettings
    
    @AppStorage("dontShowInstructions") private var dontShowInstructions = false
    
    @State private var currentPage = 0
    @State private var showSkipAlert = false
    
    var isPremium: Bool = PurchaseManager.shared.isPremium
    var isFirstLaunch: Bool = true
    var canSkip: Bool = true
    var onClose: (() -> Void)? = nil
    
    private func markTutorialAsCompleted() {
        dontShowInstructions = true
        if let uid = Auth.auth().currentUser?.uid {
            UserDefaults.standard.set(true, forKey: "has_seen_tutorial_\(uid)")
        }
        onClose?()
        dismiss()
    }
    
    private let standardPageItems: [TutorialPageItem] = [
        TutorialPageItem(
            imageName: "scr1",
            titleKey: "L10n_tutorialSlide2Title",
            descriptionKey: "L10n_tutorialSlide2Description",
            indicators: [
                IndicatorConfig(x: 0.12, y: 0.94, size: 40, color: .accentColor)
            ]
        ),
        TutorialPageItem(
            imageName: "scr2",
            titleKey: "L10n_tutorialSlide3Title",
            descriptionKey: "L10n_tutorialSlide3Description",
            indicators: [
                IndicatorConfig(x: 0.50, y: 0.25, size: 48, color: .yellow),
                IndicatorConfig(x: 0.50, y: 0.75, size: 48, color: .yellow)
            ]
        ),
        TutorialPageItem(
            imageName: "scr3",
            titleKey: "L10n_tutorialSlide4Title",
            descriptionKey: "L10n_tutorialSlide4Description",
            indicators: [
                IndicatorConfig(x: 0.12, y: 0.58, size: 55, color: .accentColor)
            ]
        ),
        TutorialPageItem(
            imageName: "scr4",
            titleKey: "L10n_tutorialSlide5Title",
            descriptionKey: "L10n_tutorialSlide5Description",
            indicators: [
                IndicatorConfig(x: 0.50, y: 0.91, size: 54, color: .accentColor)
            ]
        ),
        TutorialPageItem(
            imageName: "scr2",
            titleKey: "L10n_tutorialSlide6Title",
            descriptionKey: "L10n_tutorialSlide6Description",
            indicators: [
                IndicatorConfig(x: 0.89, y: 0.16, size: 48, color: .yellow),
                IndicatorConfig(x: 0.89, y: 0.66, size: 48, color: .yellow)
            ]
        ),
        TutorialPageItem(
            imageName: "scr5",
            titleKey: "L10n_tutorialSlide7Title",
            descriptionKey: "L10n_tutorialSlide7Description",
            indicators: [
                IndicatorConfig(x: 0.37, y: 0.94, size: 40, color: .accentColor)
            ]
        ),
        TutorialPageItem(
            imageName: "scr5",
            titleKey: "L10n_tutorialSlide8Title",
            descriptionKey: "L10n_tutorialSlide8Description",
            indicators: [
                IndicatorConfig(x: 0.72, y: 0.86, size: 54, color: .green)
            ]
        ),
        TutorialPageItem(
            imageName: "scr7",
            titleKey: "L10n_tutorialSlide9Title",
            descriptionKey: "L10n_tutorialSlide9Description",
            indicators: [
                IndicatorConfig(x: 0.62, y: 0.94, size: 42, color: .accentColor)
            ]
        ),
        TutorialPageItem(
            imageName: "scr8",
            titleKey: "L10n_tutorialSlide10Title",
            descriptionKey: "L10n_tutorialSlide10Description",
            indicators: [
                IndicatorConfig(x: 0.85, y: 0.95, size: 42, color: .accentColor)
            ]
        ),
        TutorialPageItem(
            imageName: nil,
            titleKey: "L10n_tutorialSlide11Title",
            descriptionKey: "L10n_tutorialSlide11Description",
            indicators: []
        )
    ]
    
    private var totalPages: Int {
        1 + standardPageItems.count
    }
    
    var isLastPage: Bool {
        currentPage == totalPages - 1
    }
    
    var body: some View {
        let lang = languageSettings.language
        let isNotFirstPage = currentPage > 0
        
        VStack {
            HStack {
                Text("\(currentPage + 1) / \(totalPages)")
                    .font(.airbnbBody)
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                    .padding(.top, 8)
                
                Spacer()
                
                if canSkip && !isLastPage {
                    Button(action: {
                        if isFirstLaunch {
                            showSkipAlert = true
                        } else {
                            dismiss()
                        }
                    }) {
                        Text(TutorialDictionary.text(for: "L10n_tutorialButtonSkip", lang: lang))
                            .foregroundColor(.gray)
                            .font(.airbnbBody)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 8)
                } else {
                    Spacer().frame(height: 48)
                }
            }
            .padding(.top, 12)
            
            TabView(selection: $currentPage) {
                // SLIDE 1 (Versão Free vs Premium)
                VStack(spacing: 16) {
                    Spacer()
                    
                    Text(TutorialDictionary.text(for: "L10n_tutorialSlide1Title", lang: lang))
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.top, 12)
                    
                    VStack(spacing: 18) {
                        let textContent = isPremium ? getStaticSlide1PremiumText(for: lang) : getStaticSlide1FreeText(for: lang)
                        
                        ForEach(parseSentences(textContent), id: \.self) { sentence in
                            HStack {
                                Spacer()
                                Text(sentence)
                                    .font(.system(size: 22, weight: .light, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .tag(0)
                
                // SLIDES SEGUINTES (2 em diante)
                ForEach(Array(standardPageItems.enumerated()), id: \.element.id) { index, item in
                    let slideIndex = index + 1
                    let title = TutorialDictionary.text(for: item.titleKey, lang: lang)
                    let rawDescription = TutorialDictionary.text(for: item.descriptionKey, lang: lang)
                    
                    VStack(spacing: 16) {
                        Spacer()
                        
                        // Bloco centralizado
                        ZStack {
                            if slideIndex == standardPageItems.count {
                                ParticleExplosionView()
                            } else if let imageName = item.imageName {
                                // Imagem com overlay em GeometryReader para mapear 100% da área real da imagem
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 450)
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                    .overlay(
                                        GeometryReader { geo in
                                            ZStack {
                                                ForEach(Array(item.indicators.enumerated()), id: \.offset) { _, indicator in
                                                    BlinkingIndicatorView(size: indicator.size, color: indicator.color)
                                                        .position(
                                                            x: geo.size.width * indicator.x,
                                                            y: geo.size.height * indicator.y
                                                        )
                                                }
                                            }
                                        }
                                    )
                            }
                        }
                        .frame(maxHeight: 450)
                        
                        Text(title)
                            .font(.airbnbSectionTitle)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Text(LocalizedStringKey(rawDescription))
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 14)
                            .lineSpacing(4)
                        
                        Spacer()
                    }
                    .tag(slideIndex)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Botões Inferiores
            HStack(spacing: 12) {
                if isNotFirstPage {
                    Button(action: {
                        withAnimation {
                            currentPage -= 1
                        }
                    }) {
                        Text(TutorialDictionary.text(for: "L10n_tutorialButtonPrev", lang: lang))
                            .font(.airbnbItemTitle)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                    }
                }
                
                Button(action: {
                    if isLastPage {
                        markTutorialAsCompleted()
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }) {
                    let buttonKey = isLastPage ? "L10n_tutorialButtonStart" : "L10n_tutorialButtonNext"
                    Text(TutorialDictionary.text(for: buttonKey, lang: lang))
                        .font(.airbnbItemTitle)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(isLastPage ? Color.green : Color(red: 81/255, green: 160/255, blue: 206/255))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .alert(TutorialDictionary.text(for: "L10n_tutorialSkipDialogTitle", lang: languageSettings.language), isPresented: $showSkipAlert) {
            Button(TutorialDictionary.text(for: "L10n_tutorialSkipDialogLater", lang: languageSettings.language), role: .destructive) {
                markTutorialAsCompleted()
            }
            Button(TutorialDictionary.text(for: "L10n_tutorialSkipDialogNow", lang: languageSettings.language), role: .cancel) { }
        } message: {
            Text(TutorialDictionary.text(for: "L10n_tutorialSkipDialogMessage", lang: languageSettings.language))
        }
    }
    
    private func parseSentences(_ text: String) -> [String] {
        let separators = CharacterSet(charactersIn: ".\n")
        return text.components(separatedBy: separators)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    private func getStaticSlide1FreeText(for lang: String) -> String {
        switch lang.lowercased() {
        case "pt": return "Está a usar a versão gratuita da aplicação Lisbon Seven Wonders. Tem acesso gratuito a todas as informações essenciais para explorar Lisboa e Sintra. Pode adquirir a VERSÃO PREMIUM quando quiser para desbloquear os áudioguias e histórias detalhadas. Deslize para continuar >>>"
        case "es": return "Está utilizando la versión gratuita de la aplicación Lisbon Seven Wonders. Tiene acceso gratuito a toda la información esencial para explorar Lisboa y Sintra. Puede adquirir la VERSION PREMIUM en cualquier momento para desbloquear audioguías e historias detalladas. Deslice para continuar >>>"
        case "fr": return "Vous utilisez la version gratuite de l'application Lisbon Seven Wonders. Vous avez un accès gratuit à toutes les informations essentielles pour explorer Lisbonne et Sintra. Vous pouvez acheter la VERSION PREMIUM quand vous le souhaitez pour débloquer les audioguides et des récits détaillés. Glissez pour continuer >>>"
        default: return "You are using the free version of the Lisbon Seven Wonders app. You have free access to all essential information to explore Lisbon and Sintra. You can purchase the PREMIUM VERSION whenever you like to unlock audio guides and detailed stories. Swipe to continue >>>"
        }
    }
    
    private func getStaticSlide1PremiumText(for lang: String) -> String {
        switch lang.lowercased() {
        case "pt": return "Está a usar a VERSÃO PREMIUM da aplicação Lisbon Seven Wonders. A VERSÃO PREMIUM oferece todas as funcionalidades, incluindo textos aprofundados e audioguias. Deslize para continuar >>>"
        case "es": return "Está utilizando la versión PREMIUM de la aplicación Lisbon Seven Wonders. La versión PREMIUM ofrece todas las funciones, incluyendo textos detallados y audioguías. Deslice para avanzar >>>"
        case "fr": return "Vous utilisez la version PREMIUM de l'application Lisbon Seven Wonders. La version PREMIUM offre toutes les fonctionnalités, y compris des textes approfondis et des audioguides. Glissez pour continuer >>>"
        default: return "You are using the PREMIUM VERSION of the Lisbon Seven Wonders app. The PREMIUM VERSION offers all features, including in-depth texts and audio guides. Swipe to continue >>>"
        }
    }
}

// Modelo de partícula individual para a geometria pura
struct ConfettiParticle: Identifiable {
    let id = UUID()
    let angle: Double
    let distance: CGFloat
    let color: Color
    let size: CGFloat
    let shapeType: Int
}

struct ParticleExplosionView: View {
    @State private var isExploded = false
    
    private let particles: [ConfettiParticle] = {
        let colors: [Color] = [.green, .accentColor, .yellow, .orange, .pink, .purple, .blue]
        var list: [ConfettiParticle] = []
        for i in 0..<24 {
            let angle = Double(i) * (360.0 / 24.0) * (.pi / 180.0)
            let distance = CGFloat.random(in: 60...110)
            let color = colors.randomElement() ?? .green
            let size = CGFloat.random(in: 6...12)
            let shape = Int.random(in: 0...1)
            list.append(ConfettiParticle(angle: angle, distance: distance, color: color, size: size, shapeType: shape))
        }
        return list
    }()
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .fill(Color(red: 81/255, green: 160/255, blue: 206/255).opacity(0.15))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isExploded ? 1.1 : 0.9)
                
                Circle()
                    .fill(Color(red: 81/255, green: 160/255, blue: 206/255).opacity(0.25))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(red: 81/255, green: 160/255, blue: 206/255))
                    .scaleEffect(isExploded ? 1.0 : 0.5)
                    .opacity(isExploded ? 1.0 : 0.0)
            }
            
            ForEach(particles) { particle in
                Group {
                    if particle.shapeType == 0 {
                        Circle()
                            .fill(particle.color)
                            .frame(width: particle.size, height: particle.size)
                    } else {
                        Rectangle()
                            .fill(particle.color)
                            .frame(width: particle.size, height: particle.size)
                            .rotationEffect(.degrees(isExploded ? 180 : 0))
                    }
                }
                .offset(
                    x: isExploded ? cos(particle.angle) * particle.distance : 0,
                    y: isExploded ? sin(particle.angle) * particle.distance : 0
                )
                .scaleEffect(isExploded ? 1.0 : 0.1)
                .opacity(isExploded ? 1.0 : 0.0)
            }
        }
        .frame(height: 240)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.5)) {
                isExploded = true
            }
        }
    }
}

struct BlinkingIndicatorView: View {
    var size: CGFloat = 40
    var color: Color = .accentColor
    
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .stroke(color, lineWidth: 5)
            .frame(width: size, height: size)
            .scaleEffect(isAnimating ? 1.25 : 1.0)
            .opacity(isAnimating ? 0.2 : 1.0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}
