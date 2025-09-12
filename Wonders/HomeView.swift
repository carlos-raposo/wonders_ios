import SwiftUI

struct HomeView: View {
    let categories: [(title: String, color: Color)]
    let imageNames: [String]
    let columns: [GridItem]
    @Binding var showMiniaturas: Bool
    @Binding var selectedCategoryIndex: Int?
    @Binding var selectedTab: Int
    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = 6
            let spacing: CGFloat = 10
            let totalSpacing = spacing + horizontalPadding * 2
            let itemWidth = (geometry.size.width - totalSpacing) / 2
            let enumeratedCategories = Array(categories.enumerated())
            let enumeratedImageNames = imageNames
            VStack(spacing: 0) {
                Spacer().frame(height: safeAreaTop() + 4)
                Text("Escolha uma Categoria")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 12)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(enumeratedCategories, id: \.offset) { (i, category) in
                            let imageName = enumeratedImageNames[i]
                            Button(action: {
                                selectedCategoryIndex = i
                                showMiniaturas = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(category.color)
                                        .frame(width: itemWidth, height: itemWidth)
                                    VStack(spacing: 0) {
                                        Image(imageName)
                                            .resizable()
                                            .renderingMode(Image.TemplateRenderingMode.template)
                                            .foregroundColor(Color.black)
                                            .scaledToFill()
                                            .frame(width: itemWidth, height: itemWidth)
                                            .clipped()
                                            .cornerRadius(18)
                                        Spacer(minLength: 0)
                                    }
                                    .frame(width: itemWidth, height: itemWidth)
                                    VStack {
                                        Spacer()
                                        Text(category.title)
                                            .font(.system(size: 20, weight: .regular))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 8)
                                            .padding(.bottom, 18)
                                            .shadow(color: Color.white.opacity(0.7), radius: 4, y: 1)
                                    }
                                    .frame(width: itemWidth, height: itemWidth)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, 32)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color(.systemBackground))
            .ignoresSafeArea(edges: .top)
        }
    }
}

private func safeAreaTop() -> CGFloat {
    UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow?.safeAreaInsets.top }
        .first ?? 0
}
