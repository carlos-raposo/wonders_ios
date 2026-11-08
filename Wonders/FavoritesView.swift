import SwiftUI
import MapKit

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showMapSheet = false
    @State private var selectedCard: MiniaturaCard? = nil
    @State private var showShareSheet = false
    @State private var isEditingOrder = false // Estado para ativar o modo de reordenação
    
    private func getFavoriteCards() -> [(key: String, card: MiniaturaCard, translation: MiniaturaCardTranslation)] {
        var result: [(String, MiniaturaCard, MiniaturaCardTranslation)] = []
        let allCards = MiniaturaCard.allCards()
        
        for favKey in favoritesManager.favorites {
            if let id = Int(favKey), let card = allCards.first(where: { $0.id == id }) {
                if languageSettings.language == "pt" && card.categoria == "Vocabulary" {
                    continue
                }
                let translation = card.translations[languageSettings.language]
                    ?? card.translations["en"]
                    ?? card.translations["pt"]
                    ?? card.translations.values.first
                if let translation = translation {
                    result.append((favKey, card, translation))
                }
            }
        }
        return result
    }
    
    private func imageName(for card: MiniaturaCard) -> String {
        if languageSettings.language == "en" && card.categoria == "Vocabulary" {
            return "vocabulary_en_\(card.id)"
        }
        return card.imagem
    }
    
    var body: some View {
        GeometryReader { geometry in
            let isTablet = UIDevice.current.userInterfaceIdiom == .pad
            let horizontalPadding: CGFloat = isTablet ? 32 : 16
            let spacing: CGFloat = isTablet ? 16 : 12
            
            let screenWidth = geometry.size.width
            let columnsCount: Int = {
                if screenWidth > 1100 { return 4 }
                else if screenWidth > 750 { return 3 }
                else if screenWidth > 500 { return 2 }
                else { return 2 }
            }()
            
            let totalSpacing = spacing * CGFloat(columnsCount - 1)
            let availableWidth = min(screenWidth, 1100) - (horizontalPadding * 2) - totalSpacing
            let itemWidth = max(availableWidth / CGFloat(columnsCount), 1)
            
            let columns = Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing), count: columnsCount)
            let colorScheme = UITraitCollection.current.userInterfaceStyle == .dark ? ColorScheme.dark : ColorScheme.light
            
            if geometry.size.width.isFinite, geometry.size.width > 0 {
                let favoriteCards = getFavoriteCards()
                let mapLocations: [MiniaturaLocation] = favoriteCards.flatMap { (_, card, _) in
                    card.locations?.map { loc in
                        MiniaturaLocation(title: MiniaturaCard.localizedLocationName(loc.name, lang: languageSettings.language), latitude: loc.latitude, longitude: loc.longitude, ordem: card.ordem)
                    } ?? []
                }
                let mapTitle: String = languageSettings.language == "pt" ? "Mapa de Favoritos" : "Favorites Map"
                
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        // Cabeçalho com título e botão de reordenar
                        HStack {
                            Spacer()
                            Text(languageSettings.language == "pt" ? "Favoritos" : "Favorites")
                                .font(.system(size: isTablet ? 34 : 26, weight: .regular, design: .rounded))
                                .foregroundColor(Color.primary)
                            Spacer()
                        }
                        .overlay(alignment: .trailing) {
                            if !favoriteCards.isEmpty {
                                Button(action: {
                                    withAnimation { isEditingOrder.toggle() }
                                }) {
                                    Text(isEditingOrder ?
                                        (languageSettings.language == "pt" ? "Pronto" :
                                         languageSettings.language == "es" ? "Listo" :
                                         languageSettings.language == "fr" ? "Terminé" : "Done") :
                                        (languageSettings.language == "pt" ? "Reordenar" :
                                         languageSettings.language == "es" ? "Reordenar" :
                                         languageSettings.language == "fr" ? "Réordonner" : "Reorder"))
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(red: 81/255, green: 160/255, blue: 206/255))
                                }
                                .padding(.trailing, horizontalPadding)
                            }
                        }
                        .padding(.top, isTablet ? 20 : 16)
                        .padding(.bottom, isTablet ? 28 : 20)
                        
                        if favoriteCards.isEmpty {
                            Spacer()
                            Text(languageSettings.language == "pt" ? "Nenhum favorito ainda" : "No favorites yet")
                                .font(.system(size: isTablet ? 22 : 18, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                                .padding()
                            Spacer()
                        } else {
                            ScrollView {
                                VStack(spacing: 0) {
                                    LazyVGrid(columns: columns, spacing: spacing) {
                                        ForEach(Array(favoriteCards.enumerated()), id: \.element.key) { index, element in
                                            let card = element.card
                                            let translation = element.translation
                                            
                                            VStack(alignment: .center, spacing: 10) {
                                                ZStack(alignment: .center) {
                                                    // Cartão de fundo (Imagem)
                                                    Button(action: {
                                                        if !isEditingOrder { selectedCard = card }
                                                    }) {
                                                        Image(imageName(for: card))
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: itemWidth, height: itemWidth)
                                                            .clipped()
                                                            .cornerRadius(16)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                    
                                                    // Se estiver em modo de edição, mostra sempre as 4 setas em cruz em todos os cartões
                                                    if isEditingOrder {
                                                        Color.black.opacity(0.6)
                                                            .cornerRadius(16)
                                                        
                                                        ZStack {
                                                            // Seta para Cima (sempre visível; desativada se estiver no topo)
                                                            Button(action: {
                                                                if index - columnsCount >= 0 {
                                                                    withAnimation {
                                                                        favoritesManager.moveItem(from: index, to: index - columnsCount)
                                                                    }
                                                                }
                                                            }) {
                                                                Image(systemName: "chevron.up")
                                                                    .font(.system(size: 24, weight: .bold))
                                                                    .foregroundColor(.white)
                                                                    .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 1)
                                                            }
                                                            .offset(y: -38)
                                                            .opacity(index - columnsCount >= 0 ? 1.0 : 0.3) // Fica mais transparente se não houver para onde subir
                                                            
                                                            // Seta para Baixo (permite mover até ao limite máximo do array)
                                                            // Seta para Baixo (permite descer se não for o último elemento)
                                                            Button(action: {
                                                                if index < favoriteCards.count - 1 {
                                                                    withAnimation {
                                                                        let target = min(index + columnsCount, favoriteCards.count - 1)
                                                                        favoritesManager.moveItem(from: index, to: target)
                                                                    }
                                                                }
                                                            }) {
                                                                Image(systemName: "chevron.down")
                                                                    .font(.system(size: 24, weight: .bold))
                                                                    .foregroundColor(.white)
                                                                    .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 1)
                                                            }
                                                            .offset(y: 38)
                                                            .opacity(index < favoriteCards.count - 1 ? 1.0 : 0.3)
                                                            
                                                            // Seta para a Esquerda (sempre visível; desativada no primeiro item)
                                                            Button(action: {
                                                                if index > 0 {
                                                                    withAnimation {
                                                                        favoritesManager.moveItem(from: index, to: index - 1)
                                                                    }
                                                                }
                                                            }) {
                                                                Image(systemName: "chevron.left")
                                                                    .font(.system(size: 24, weight: .bold))
                                                                    .foregroundColor(.white)
                                                                    .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 1)
                                                            }
                                                            .offset(x: -38)
                                                            .opacity(index > 0 ? 1.0 : 0.3)
                                                            
                                                            // Seta para a Direita (sempre visível; desativada no último item)
                                                            Button(action: {
                                                                if index < favoriteCards.count - 1 {
                                                                    withAnimation {
                                                                        favoritesManager.moveItem(from: index, to: index + 1)
                                                                    }
                                                                }
                                                            }) {
                                                                Image(systemName: "chevron.right")
                                                                    .font(.system(size: 24, weight: .bold))
                                                                    .foregroundColor(.white)
                                                                    .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 1)
                                                            }
                                                            .offset(x: 38)
                                                            .opacity(index < favoriteCards.count - 1 ? 1.0 : 0.3)
                                                        }
                                                    }else {
                                                        // Botão normal de favorito (canto superior direito)
                                                        VStack {
                                                            HStack {
                                                                Spacer()
                                                                Button(action: {
                                                                    favoritesManager.toggleFavorite(card: card)
                                                                }) {
                                                                    Image(systemName: "heart.fill")
                                                                        .foregroundColor(.red)
                                                                        .font(.system(size: isTablet ? 20 : 16))
                                                                        .padding(8)
                                                                }
                                                                .frame(width: 44, height: 44)
                                                                .contentShape(Circle())
                                                                .padding(4)
                                                            }
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                                .frame(width: itemWidth, height: itemWidth)
                                                
                                                Text(translation.titulo)
                                                    .font(.system(size: isTablet ? 16 : 14, weight: .medium, design: .rounded))
                                                    .foregroundColor(.primary)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(1)
                                                    .frame(width: itemWidth)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, horizontalPadding)
                                    .frame(maxWidth: 1100)
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 100)
                                }
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(Color(.systemBackground))
                    .ignoresSafeArea(edges: .bottom)
                    
                    // Botões flutuantes inferiores (Mapa / Partilhar)
                    HStack {
                        Spacer()
                        Button(action: { showMapSheet = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "map")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundColor(.primary)
                                Text(languageSettings.language == "pt" ? "Mapa" : "Map")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.regularMaterial)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.primary.opacity(0.2), lineWidth: 1))
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.6 : 0.15), radius: 4)
                        }
                        
                        Spacer()
                        
                        Button(action: { showShareSheet = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundColor(.primary)
                                Text(languageSettings.language == "pt" ? "Partilhar" : "Share")
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.regularMaterial)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.primary.opacity(0.2), lineWidth: 1))
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.6 : 0.15), radius: 4)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 12)
                }
                .sheet(isPresented: $showMapSheet) {
                    MiniaturasMapView(
                        locations: mapLocations,
                        mapTitle: mapTitle,
                        showNumbers: false,
                        zoomSpan: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04),
                        customCenter: mapLocations.first?.coordinate
                    )
                }
                .background(
                    Group {
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            Color.clear.fullScreenCover(item: $selectedCard) { card in
                                CardsDeckPage(card: card, language: languageSettings.language)
                                    .environmentObject(favoritesManager)
                                    .environmentObject(languageSettings)
                                    .environmentObject(purchaseManager)
                            }
                        } else {
                            Color.clear.sheet(item: $selectedCard) { card in
                                CardsDeckPage(card: card, language: languageSettings.language)
                                    .environmentObject(favoritesManager)
                                    .environmentObject(languageSettings)
                                    .environmentObject(purchaseManager)
                            }
                        }
                    }
                )
                .sheet(isPresented: $showShareSheet) {
                    let favoritesList = favoriteCards.map { element in
                        let translation = element.2
                        // Junta o título e, se existir shortDescription, adiciona-a numa nova linha
                        var text = "• " + translation.titulo
                        let shortDesc = translation.shortDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !shortDesc.isEmpty {
                            text += "\n  \(shortDesc)"
                        }
                        return text
                    }.joined(separator: "\n\n")
                    
                    ActivityView(activityItems: [favoritesList])
                }
            } else {
                Color.clear
            }
        }
    }
}

// Helpers
fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
