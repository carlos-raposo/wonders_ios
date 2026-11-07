import SwiftUI

struct HomeCategoryItem {
    let titleKey: String
    let svgName: String
    let lightBgColor: Color
}

struct HomeView: View {
    @Binding var showMiniaturas: Bool
    @Binding var selectedCategoryIndex: Int?
    @Binding var selectedTab: Int
    @EnvironmentObject var languageSettings: LanguageSettings

    private let categoryItems: [HomeCategoryItem] = [
        HomeCategoryItem(titleKey: "Monuments", svgName: "monuments", lightBgColor: Color(red: 255/255, green: 228/255, blue: 142/255)),
        HomeCategoryItem(titleKey: "Nature", svgName: "nature", lightBgColor: Color(red: 192/255, green: 255/255, blue: 195/255)),
        HomeCategoryItem(titleKey: "Gastronomy", svgName: "gastronomy", lightBgColor: Color(red: 198/255, green: 229/255, blue: 255/255)),
        HomeCategoryItem(titleKey: "Popular", svgName: "popular", lightBgColor: Color(red: 255/255, green: 189/255, blue: 168/255)),
        HomeCategoryItem(titleKey: "Churches", svgName: "churches", lightBgColor: Color(red: 255/255, green: 225/255, blue: 235/255)),
        HomeCategoryItem(titleKey: "Museums", svgName: "museums", lightBgColor: Color(red: 189/255, green: 255/255, blue: 246/255)),
        HomeCategoryItem(titleKey: "Sintra", svgName: "sintra", lightBgColor: Color(red: 238/255, green: 229/255, blue: 255/255)),
        HomeCategoryItem(titleKey: "Vocabulary", svgName: "linguagem", lightBgColor: Color(red: 251/255, green: 255/255, blue: 187/255))
    ]

    private let translations: [String: [String: String]] = [
        "en": [
            "choose_category": "What to explore?",
            "Monuments": "Monuments",
            "Nature": "Nature",
            "Gastronomy": "Gastronomy",
            "Popular": "Popular",
            "Churches": "Churches",
            "Museums": "Museums",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulary"
        ],
        "pt": [
            "choose_category": "O que quer explorar?",
            "Monuments": "Monumentos",
            "Nature": "Natureza",
            "Gastronomy": "Gastronomia",
            "Popular": "Popular",
            "Churches": "Igrejas",
            "Museums": "Museus",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulário"
        ],
        "fr": [
            "choose_category": "Que voulez-vous explorer?",
            "Monuments": "Monuments",
            "Nature": "Nature",
            "Gastronomy": "Gastronomie",
            "Popular": "Populaire",
            "Churches": "Églises",
            "Museums": "Musées",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulaire"
        ],
        "es": [
            "choose_category": "¿Qué quieres explorar?",
            "Monuments": "Monumentos",
            "Nature": "Naturaleza",
            "Gastronomy": "Gastronomía",
            "Popular": "Popular",
            "Churches": "Iglesias",
            "Museums": "Museos",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulario"
        ]
    ]

    private func t(_ key: String) -> String {
        translations[languageSettings.language]?[key] ?? translations["en"]![key]!
    }

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let isTablet = UIDevice.current.userInterfaceIdiom == .pad
            
            // 🌟 Cálculo dinâmico idêntico ao de Favoritos (2, 3 ou 4 colunas)
            let columnsCount: Int = {
                if screenWidth > 1100 { return 4 }      // Tablets muito grandes / Paisagem
                else if screenWidth > 750 { return 3 }  // Tablets médios
                else if screenWidth > 500 { return 2 }  // Tablets pequenos / iPhone Max em paisagem
                else { return 2 }                       // Telemóveis padrão
            }()
            
            let horizontalPadding: CGFloat = isTablet ? 32 : 16
            let gridSpacing: CGFloat = isTablet ? 16 : 12
            
            let totalSpacing = gridSpacing * CGFloat(columnsCount - 1)
            let availableWidth = min(screenWidth, 1100) - (horizontalPadding * 2) - totalSpacing
            let itemWidth = max(availableWidth / CGFloat(columnsCount), 1)
            
            let columns = Array(repeating: GridItem(.fixed(itemWidth), spacing: gridSpacing), count: columnsCount)
            let iconSize = min(max(itemWidth * 0.65, 50), 160)

            VStack(spacing: 0) {
                            // 🌟 CABEÇALHO IDÊNTICO AO DA MiniaturasCategoryView (ZStack com altura fixa)
                            ZStack {
                                HStack {
                                    // Espaço vazio à esquerda (simétrico ao botão de voltar das outras vistas)
                                    Color.clear
                                        .frame(width: 44, height: 44)
                                        .padding(.horizontal, 16)
                                    
                                    Spacer()
                                }
                                
                                Text(t("choose_category"))
                                    .font(.system(size: isTablet ? 26 : 24, weight: .regular, design: .rounded)) // 👈 Tamanho unificado (24/26)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                    .padding(.horizontal, 60)
                                
                                HStack {
                                    Spacer()
                                    Color.clear
                                        .frame(width: 44, height: 44)
                                        .padding(.horizontal, 16)
                                }
                            }
                            .frame(height: 40) // 👈 Altura exata de 40 pontos igual à outra vista
                            .background(Color(.systemBackground))
                            
                            // CONTEÚDO A DESLIZAR ABAIXO DO CABEÇALHO
                            ScrollView {
                                // Respiro inicial idêntico
                                Spacer().frame(height: 12)
                                
                                LazyVGrid(columns: columns, spacing: gridSpacing) {
                                    ForEach(Array(categoryItems.enumerated()), id: \.offset) { index, item in
                                        Button(action: {
                                            selectedCategoryIndex = index
                                            showMiniaturas = true
                                        }) {
                                            ZStack {
                                                // 1. FUNDO DO CARTÃO
                                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                                    .fill(item.lightBgColor)
                                                    .frame(width: itemWidth, height: itemWidth)

                                                // 2. ÍCONE SVG
                                                Image(item.svgName)
                                                    .resizable()
                                                    .renderingMode(.original)
                                                    .scaledToFit()
                                                    .frame(width: iconSize, height: iconSize)

                                                // 3. TÍTULO DO CARTÃO
                                                VStack {
                                                    Spacer()
                                                    Text(t(item.titleKey))
                                                        .font(.system(size: isTablet ? 22 : 20, weight: .light, design: .rounded))
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)
                                                        .padding(.horizontal, 6)
                                                        .padding(.bottom, 12)
                                                }
                                                .frame(width: itemWidth, height: itemWidth)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, horizontalPadding)
                                .frame(maxWidth: 1100)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 32)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .background(Color(.systemBackground))
            // Nota: Removemos o .ignoresSafeArea(edges: .top) para respeitar a área segura do topo!
        }
    }
}

private func safeAreaTop() -> CGFloat {
    UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow?.safeAreaInsets.top }
        .first ?? 0
}
