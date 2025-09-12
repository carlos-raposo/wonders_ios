import SwiftUI

struct MiniaturasView: View {
    let categories: [String]
    @State private var selectedCategory: Int
    @Namespace private var underline
    @Binding var selectedTab: Int
    @Binding var showMiniaturas: Bool
    
    init(categories: [String], initialCategory: Int, selectedTab: Binding<Int>, showMiniaturas: Binding<Bool>) {
        self.categories = categories
        _selectedCategory = State(initialValue: initialCategory)
        self._selectedTab = selectedTab
        self._showMiniaturas = showMiniaturas
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom AppBar: Back arrow + categories
            HStack(spacing: 0) {
                Button(action: { showMiniaturas = false }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.trailing, 8)
                        .padding(.leading, 8)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<categories.count, id: \.self) { idx in
                            Button(action: {
                                withAnimation {
                                    selectedCategory = idx
                                }
                            }) {
                                VStack {
                                    Text(categories[idx])
                                        .fontWeight(selectedCategory == idx ? .bold : .regular)
                                        .foregroundColor(selectedCategory == idx ? .blue : .primary)
                                    if selectedCategory == idx {
                                        Capsule()
                                            .fill(Color.blue)
                                            .frame(height: 3)
                                            .matchedGeometryEffect(id: "underline", in: underline)
                                    } else {
                                        Capsule()
                                            .fill(Color.clear)
                                            .frame(height: 3)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .background(Color(.systemBackground))
            Divider()
            // Swipe lateral entre categorias
            TabView(selection: $selectedCategory) {
                ForEach(0..<categories.count, id: \.self) { idx in
                    MiniaturasCategoryView(category: categories[idx])
                        .tag(idx)
                        .padding(.top, 8)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationBarHidden(true)
        // REMOVED .safeAreaInset(edge: .bottom) for tab bar
    }
}

struct MiniaturasCategoryView: View {
    let category: String
    @State private var showDeckPage: MiniaturaCard? = nil
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Text("Miniaturas de \(category)")
                    .font(.title2)
                    .padding()
                    .accessibilityLabel("Categoria: \(category)")
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(MiniaturaCard.mockCards(for: category)) { card in
                            VStack(spacing: 0) {
                                Button(action: { showDeckPage = card }) {
                                    MiniaturaCardView(card: card)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .accessibilityLabel("Miniatura número \(card.ordem): \(card.titulo)")
                                VStack(spacing: 4) {
                                    Text(card.titulo)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                    Text(card.descricao)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.horizontal, 8)
                                .padding(.top, 8)
                                .padding(.bottom, 16)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            // Floating Map Button (except Vocabulary)
            if category != "Vocabulary" {
                Button(action: { /* abrir mapa da categoria */ }) {
                    HStack {
                        Image(systemName: "map")
                        Text("Mapa")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .shadow(radius: 4)
                }
                .padding(24)
                .accessibilityLabel("Abrir mapa da categoria \(category)")
            }
        }
        .sheet(item: $showDeckPage) { card in
            CardsDeckPage(card: card)
        }
    }
}

struct MiniaturaCardView: View {
    let card: MiniaturaCard
    @State private var isFavorite = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topLeading) {
                    Image(card.imagem)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(16)
                        .accessibilityLabel("Imagem da miniatura \(card.titulo)")
                    // Ordem/number circle
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
                // Favorite button
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(8)
                .accessibilityLabel(isFavorite ? "Remover dos favoritos" : "Adicionar aos favoritos")
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

// Placeholder para página de detalhes
struct CardsDeckPage: View, Identifiable {
    let id = UUID()
    let card: MiniaturaCard
    var body: some View {
        VStack(spacing: 24) {
            Image(card.imagem)
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
                .accessibilityLabel("Imagem da miniatura \(card.titulo)")
            Text(card.titulo)
                .font(.largeTitle)
                .bold()
            Text(card.descricao)
                .font(.title3)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .accessibilityElement(children: .combine)
    }
}

// MARK: - MiniaturaCard Model
struct MiniaturaCard: Identifiable {
    let id: Int
    let titulo: String
    let descricao: String
    let imagem: String // nome do asset
    let categoria: String
    let ordem: Int
}

// MARK: - Mock Data
extension MiniaturaCard {
    static func mockCards(for categoria: String) -> [MiniaturaCard] {
        // Aceita tanto "Monumentos" quanto "Monuments"
        if categoria == "Monumentos" || categoria == "Monuments" {
            return [
                MiniaturaCard(id: 1, titulo: "São Jorge Castle", descricao: "Founded in the 10th by the Moors and conquered by the first king of Portugal in 1147.", imagem: "sao_jorge_castle", categoria: categoria, ordem: 1),
                MiniaturaCard(id: 2, titulo: "Belém Tower", descricao: "Built in the early 16th century, it is a portal to Portugal’s maritime past.", imagem: "torre_belem", categoria: categoria, ordem: 2),
                MiniaturaCard(id: 3, titulo: "Águas Livres Aqueduct", descricao: "A remarkable 18th-century aqueduct that supplied Lisbon with water.", imagem: "aqueduto", categoria: categoria, ordem: 3),
                MiniaturaCard(id: 4, titulo: "Arco da Rua Augusta", descricao: "A triumphal arch and symbol of Lisbon’s rebirth after the earthquake.", imagem: "comercio", categoria: categoria, ordem: 4),
                MiniaturaCard(id: 5, titulo: "Santa Justa Lift", descricao: "A 19th-century elevator with panoramic city views.", imagem: "santa_justa", categoria: categoria, ordem: 5),
                MiniaturaCard(id: 6, titulo: "Padrão dos Descobrimentos", descricao: "A tribute to the Portuguese Age of Discovery, on the Tagus riverbank.", imagem: "padrao", categoria: categoria, ordem: 6),
                MiniaturaCard(id: 7, titulo: "Pontes de Lisboa", descricao: "Pontes de Lisboa maravilhosas e históricas.", imagem: "ponte_25_abril", categoria: categoria, ordem: 7),
                MiniaturaCard(id: 8, titulo: "Mais Monumentos", descricao: "Lisboa tem muitos monumentos incríveis!", imagem: "plus_monuments", categoria: categoria, ordem: 8)
            ]
        }
        let imagePrefix: String
        switch categoria {
        case "Natureza": imagePrefix = "nature"
        case "Gastronomy": imagePrefix = "gastronomy"
        case "Popular": imagePrefix = "popular"
        case "Churches": imagePrefix = "churches"
        case "Museums": imagePrefix = "museums"
        case "Sintra": imagePrefix = "sintra"
        case "Vocabulary": imagePrefix = "vocabulary"
        default: imagePrefix = "monuments"
        }
        return (1...8).map { i in
            MiniaturaCard(
                id: i,
                titulo: "Título \(i) - \(categoria)",
                descricao: "Descrição do cartão \(i) da categoria \(categoria).",
                imagem: "\(imagePrefix)\(i)",
                categoria: categoria,
                ordem: i
            )
        }
    }
}

struct MiniaturasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MiniaturasView(categories: [
                "Monuments", "Nature", "Gastronomy", "Popular", "Churches", "Museums", "Sintra", "Vocabulary"
            ], initialCategory: 0, selectedTab: .constant(0), showMiniaturas: .constant(true))
        }
    }
}
