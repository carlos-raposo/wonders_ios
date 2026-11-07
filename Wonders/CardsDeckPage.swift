import SwiftUI
import MapKit
import FirebaseAuth

struct CardsDeckPage: View, Identifiable {
    let id = UUID()
    let card: MiniaturaCard
    let language: String
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showPremiumModal: Bool = false
    @State private var showMapSheet = false
    @AppStorage("isUserLoggedIn") private var isAuthenticated = false
    @State private var showAuthModal = false
    @State private var showSignIn = false
    @State private var customAuthMessage: String? = nil
    @Environment(\.colorScheme) var colorScheme
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    var translation: MiniaturaCardTranslation {
        card.translations[language] ?? card.translations["en"]!
    }
    
    var langCode: String {
        String(languageSettings.language.prefix(2)).lowercased()
    }
    
    var currentLang: String {
        let lang = language.lowercased()
        if lang.hasPrefix("pt") { return "pt" }
        if lang.hasPrefix("fr") { return "fr" }
        if lang.hasPrefix("es") { return "es" }
        return "en"
    }
    
    var cardIdString: String {
        "\(card.ordem)"
    }
    
    var mapLocations: [MiniaturaLocation] {
        var locations: [MiniaturaLocation] = []
        for loc in card.locations ?? [] {
            locations.append(MiniaturaLocation(title: MiniaturaCard.localizedLocationName(loc.name, lang: languageSettings.language), latitude: loc.latitude, longitude: loc.longitude, ordem: card.ordem))
        }
        return locations
    }
    
    var body: some View {
        let canFavorite = !(language == "pt" && card.categoria == "Vocabulary")
        let canShowMap = card.categoria.normalized != "vocabulary"
        let isTablet = UIDevice.current.userInterfaceIdiom == .pad
        
        ZStack(alignment: .bottom) {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // CONTEÚDO PRINCIPAL A DESLIZAR
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(alignment: .center, spacing: 16) {
                        
                        // Indicador visual de deslizar (Apenas visível em Telemóvel)
                        if !isTablet {
                            Capsule()
                                .fill(Color.secondary.opacity(0.4))
                                .frame(width: 36, height: 5)
                                .padding(.top, 10)
                        }
                        
                        // Âncora para o topo
                        Color.clear
                            .frame(height: 0)
                            .id("top")
                        
                        // 🌟 BARRA DE TOPO COM O XMARK (Apenas em Tablet)
                        if isTablet {
                            HStack {
                                Spacer()
                                Button(action: { dismiss() }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .foregroundColor(.primary)
                                        .padding(10)
                                        .background(Color(.systemGray5))
                                        .clipShape(Circle())
                                }
                                .accessibilityLabel("Fechar")
                            }
                            .padding(.horizontal, isTablet ? 32 : 16)
                            .padding(.top, 16)
                            .padding(.bottom, 4)
                        }
                        
                        // 3. IMAGEM DO CARTÃO
                        ZStack(alignment: .topTrailing) {
                            Image(card.imagem)
                                .resizable()
                                .aspectRatio(16.0/10.0, contentMode: .fill)
                                .frame(maxWidth: isTablet ? 750 : .infinity)
                                .clipped()
                                .accessibilityLabel("Imagem da miniatura \(translation.titulo)")
                            
                            if canFavorite {
                                Button(action: {
                                    if isAuthenticated && Auth.auth().currentUser != nil {
                                        favoritesManager.toggleFavorite(card: card)
                                    } else {
                                        customAuthMessage = nil
                                        showAuthModal = true
                                    }
                                }) {
                                    Image(systemName: favoritesManager.isFavorite(card: card) ? "heart.fill" : "heart")
                                        .font(.system(size: isTablet ? 28 : 24, weight: .medium, design: .rounded))
                                        .foregroundColor(favoritesManager.isFavorite(card: card) ? .red : .white)
                                        .padding(isTablet ? 16 : 10)
                                }
                                .padding(12)
                                .accessibilityLabel(favoritesManager.isFavorite(card: card) ? "Remover dos favoritos" : "Adicionar aos favoritos")
                            }
                        }
                        .frame(maxWidth: isTablet ? 750 : .infinity)
                        .cornerRadius(isTablet ? 16 : 0)
                        
                        // TÍTULO POR BAIXO DA IMAGEM (Limitado à largura do texto)
                        Text(translation.titulo)
                            .font(.system(size: isTablet ? 28 : 24, weight: .regular, design: .rounded))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: isTablet ? 750 : .infinity, alignment: .center)
                            .padding(.horizontal, 16)
                            .padding(.top, 4)
                        
                        // 4. CONTEÚDO E LEITOR DE ÁUDIO
                        VStack(alignment: .leading, spacing: 16) {
                            Group {
                                AudioPlayerView(
                                    cardId: cardIdString,
                                    currentLang: langCode,
                                    isDarkMode: colorScheme == .dark,
                                    isPremium: purchaseManager.isPurchased,
                                    onFreeUserTap: {
                                        showPremiumModal = true
                                    }
                                )
                                .padding(.horizontal)
                                
                                if let description = translation.description, !description.isEmpty {
                                    Text(description)
                                        .font(.system(size: isTablet ? 22 : 18, weight: .light, design: .rounded))
                                        .lineSpacing(6)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal)
                                }
                                
                                if hasDeepContent {
                                    if purchaseManager.isPurchased {
                                        deepContentSections
                                    } else {
                                        ZStack(alignment: .bottom) {
                                            VStack(alignment: .leading, spacing: 16) {
                                                deepContentSections
                                            }
                                            .frame(maxHeight: 180, alignment: .top)
                                            .clipped()
                                            .blur(radius: 3)
                                            
                                            LinearGradient(
                                                colors: [Color(.systemBackground).opacity(0.1), Color(.systemBackground)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                            .frame(height: 120)
                                        }
                                        
                                        // 🌟 CARTÃO ÚNICO DE DESBLOQUEIO PREMIUM
                                        VStack(spacing: 14) {
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 26, weight: .regular, design: .rounded))
                                                .foregroundColor(.accent)
                                            
                                            Text(unlockTitleText)
                                                .font(.system(size: isTablet ? 26 : 22, weight: .bold, design: .rounded))
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                            
                                            Text(unlockDescText)
                                                .font(.system(size: isTablet ? 24 : 20, weight: .light, design: .rounded))
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal, 4)
                                            
                                            Text(unlockPaymentText)
                                                .font(.system(size: 19, weight: .regular, design: .rounded))
                                                .foregroundColor(.primary)
                                                .padding(.top, 2)
                                            
                                            Button(action: { showPremiumModal = true }) {
                                                Text(unlockButtonText)
                                                    .font(.system(size: 22, weight: .medium, design: .rounded))
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 14)
                                                    .background(Color(red: 79/255, green: 123/255, blue: 159/255))
                                                    .foregroundColor(.white)
                                                    .cornerRadius(14)
                                            }
                                            .padding(.top, 4)
                                            
                                            Button(action: {
                                                withAnimation {
                                                    proxy.scrollTo("top", anchor: .top)
                                                }
                                            }) {
                                                Text(freeVersionText)
                                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                                    .foregroundColor(.primary)
                                                    .underline()
                                            }
                                            .padding(.top, 12)
                                            .padding(.bottom, 12)
                                        }
                                        .padding(20)
                                        .background(colorScheme == .dark ? Color(.systemGray6).opacity(0.3) : Color(.systemBackground))
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.blue.opacity(0.25), lineWidth: 1.5)
                                        )
                                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 8, x: 0, y: 4)
                                        .padding(.horizontal)
                                        .padding(.top, 12)
                                    }
                                }
                                
                                if let adress = translation.adress, !adress.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(Translations.shared.t("adress", lang: language))
                                            .font(.system(size: isTablet ? 22 : 20, weight: .medium, design: .rounded))
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.bottom, 8)
                                        Text(adress)
                                            .font(.system(size: isTablet ? 20 : 18, weight: .light, design: .rounded))
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 16)
                                }
                            }
                        }
                        .frame(maxWidth: isTablet ? 750 : .infinity)
                        
                        Spacer(minLength: 48)
                    }
                    .onAppear {
                        self.scrollProxy = proxy
                    }
                }
            }
            
            // BOTÃO DE MAPA FLUTUANTE (Em baixo)
            if canShowMap {
                HStack {
                    Spacer()
                    Button(action: { showMapSheet = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "map")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.primary)
                            Text(mapButtonText)
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.regularMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.primary.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.6 : 0.15), radius: 4)
                    }
                    .accessibilityLabel(openMapAccessibilityText)
                    Spacer()
                }
                .padding(.bottom, 12)
            }
        }
        .sheet(isPresented: $showMapSheet) {
            let allLocations = mapLocations
            let zoomSpan = card.zoomSpan != nil ? MKCoordinateSpan(latitudeDelta: card.zoomSpan!.latitudeDelta, longitudeDelta: card.zoomSpan!.longitudeDelta) : MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let customCenter = card.customCenter != nil ? CLLocationCoordinate2D(latitude: card.customCenter!.latitude, longitude: card.customCenter!.longitude) : (allLocations.first?.coordinate ?? CLLocationCoordinate2D(latitude: 38.7223, longitude: -9.1393))
            
            MiniaturasMapView(
                locations: allLocations,
                mapTitle: translation.titulo,
                showNumbers: true,
                zoomSpan: zoomSpan,
                customCenter: customCenter
            )
        }
        .sheet(isPresented: $showPremiumModal) {
            PremiumModalView(onContinueFree: {
                withAnimation {
                    scrollProxy?.scrollTo("top", anchor: .top)
                }
            })
            .environmentObject(languageSettings)
            .environmentObject(purchaseManager)
        }
        .alert(isPresented: $showAuthModal) {
            Alert(
                title: Text(authTitleText),
                message: Text(customAuthMessage ?? authMessageText),
                primaryButton: .default(Text(signInButtonText)) {
                    showSignIn = true
                },
                secondaryButton: .cancel(Text("X"))
            )
        }
        .sheet(isPresented: $showSignIn) {
            LoginView(onAuthenticated: { showSignIn = false })
                .environmentObject(languageSettings)
        }
    }
    
    // MARK: - Traduções Dinâmicas
    
    var unlockTitleText: String {
        switch currentLang {
        case "pt": return "Desbloquear Guia Completo"
        case "fr": return "Débloquer le guide complet"
        case "es": return "Desbloquear guía completa"
        default: return "Unlock Full Guide"
        }
    }
    
    var unlockDescText: String {
        switch currentLang {
        case "pt": return "A versão que está a usar tem tudo o que precisa para uma visita rápida mas se quer enriquecer a sua experiência com guias de áudio e textos desenvolvidos considere adquirir a versão premium."
        case "fr": return "La version que vous utilisez a tout ce dont vous avez besoin pour une visite rapide, mais si vous souhaitez enrichir votre expérience avec des guides audio et des textes détaillés, pensez à acquérir la version premium."
        case "es": return "La versión que estás usando tiene todo lo que necesitas para una visita rápida, pero si quieres enriquecer tu experiencia con guías de audio y textos detallados, considera adquirir la versión premium."
        default: return "The version you are using has everything you need for a quick visit, but if you want to take your experience further with audio guides and detailed texts, consider acquiring the premium version."
        }
    }
    
    var unlockPaymentText: String {
        switch currentLang {
        case "pt": return "Pagamento único • Válido por 1 ano"
        case "fr": return "Paiement unique • Valable 1 an"
        case "es": return "Pago único • Válido por 1 año"
        default: return "Single payment • Valid for 1 year"
        }
    }
    
    var unlockButtonText: String {
        let price = purchaseManager.products.first?.displayPrice ?? "9,99 €"
        switch currentLang {
        case "pt": return "Desbloquear \(price)"
        case "fr": return "Débloquer \(price)"
        case "es": return "Desbloquear \(price)"
        default: return "Unlock \(price)"
        }
    }
    
    var freeVersionText: String {
        switch currentLang {
        case "pt": return "Continuar com Versão Gratuita"
        case "fr": return "Continuer avec la version gratuite"
        case "es": return "Continuar con la versión gratuita"
        default: return "Continue with Free Version"
        }
    }
    
    var mapButtonText: String {
        switch currentLang {
        case "pt": return "Mapa"
        case "fr": return "Carte"
        case "es": return "Mapa"
        default: return "Map"
        }
    }
    
    var openMapAccessibilityText: String {
        switch currentLang {
        case "pt": return "Abrir mapa da miniatura"
        case "fr": return "Ouvrir la carte de l'élément"
        case "es": return "Abrir mapa del elemento"
        default: return "Open item map"
        }
    }
    
    var authTitleText: String {
        switch currentLang {
        case "pt": return "Autenticação necessária"
        case "fr": return "Authentification requise"
        case "es": return "Autenticación requerida"
        default: return "Authentication required"
        }
    }
    
    var authMessageText: String {
        switch currentLang {
        case "pt": return "Faça login para adicionar favoritos."
        case "fr": return "Veuillez vous connecter pour ajouter des favoris."
        case "es": return "Inicia sesión para añadir favoritos."
        default: return "Please log in to add favorites."
        }
    }
    
    var signInButtonText: String {
        switch currentLang {
        case "pt": return "Entrar"
        case "fr": return "Se connecter"
        case "es": return "Iniciar sesión"
        default: return "Sign In"
        }
    }
    
    private var hasDeepContent: Bool {
        (translation.history != nil && !translation.history!.isEmpty) ||
        (translation.destaques != nil && !translation.destaques!.isEmpty) ||
        (translation.usage != nil && !translation.usage!.isEmpty) ||
        (translation.pronunciation != nil && !translation.pronunciation!.isEmpty)
    }
    
    @ViewBuilder
    private var deepContentSections: some View {
        let isTablet = UIDevice.current.userInterfaceIdiom == .pad
        let bodyFont = Font.system(size: isTablet ? 22 : 18, weight: .light, design: .rounded)
        
        if let history = translation.history, !history.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(Translations.shared.t("history", lang: language))
                    .font(.system(size: isTablet ? 22 : 20, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)
                Text(history)
                    .font(bodyFont)
                    .lineSpacing(6)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        
        if let destaques = translation.destaques, !destaques.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(Translations.shared.t("highlights", lang: language))
                    .font(.system(size: isTablet ? 22 : 20, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)
                Text(destaques)
                    .font(bodyFont)
                    .lineSpacing(6)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        
        if let usage = translation.usage, !usage.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(Translations.shared.t("usage", lang: language))
                    .font(.system(size: isTablet ? 22 : 20, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)
                Text(usage)
                    .font(bodyFont)
                    .lineSpacing(6)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        
        if let pronunciation = translation.pronunciation, !pronunciation.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(Translations.shared.t("pronunciation", lang: language))
                    .font(.system(size: isTablet ? 22 : 20, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)
                Text(pronunciation)
                    .font(bodyFont)
                    .lineSpacing(6)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}
