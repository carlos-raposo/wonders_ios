import SwiftUI

struct InstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var languageSettings: LanguageSettings
    @AppStorage("dontShowInstructions") private var dontShowAgain = false
    
    @State private var currentPage = 0
    var onOK: () -> Void = {}
    
    private var isPortuguese: Bool {
        languageSettings.language.lowercased().hasPrefix("pt")
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Barra Superior
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                    onOK()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding([.top, .trailing])
            
            // Conteúdo Paginado
            TabView(selection: $currentPage) {
                // Passo 1: Bem-vindo e Categorias
                TutorialStepView(
                    iconName: "map.fill",
                    iconColor: .purple,
                    title: isPortuguese ? "Explorar Lisboa" : "Explore Lisbon",
                    description: isPortuguese
                        ? "As 7 Maravilhas estão organizadas por categorias, cada uma com 7 destaques imperdíveis e sugestões exclusivas."
                        : "The 7 Wonders are organized by categories, each with 7 must-see highlights and exclusive suggestions."
                )
                .tag(0)
                
                // Passo 2: Guias de Áudio
                TutorialStepView(
                    iconName: "headphones",
                    iconColor: .orange,
                    title: isPortuguese ? "Audioguias Inline" : "Inline Audio Guides",
                    description: isPortuguese
                        ? "Ouve narrativas detalhadas sobre a história e os segredos de cada monumento diretamente nos cartões."
                        : "Listen to detailed narratives about the history and secrets of each monument directly inside the cards."
                )
                .tag(1)
                
                // Passo 3: Favoritos e Partilha
                TutorialStepView(
                    iconName: "heart.fill",
                    iconColor: .red,
                    title: isPortuguese ? "Favoritos e Partilha" : "Favorites & Share",
                    description: isPortuguese
                        ? "Guarda os teus locais preferidos tocando no coração e partilha o teu itinerário personalizado com amigos."
                        : "Save your favorite spots by tapping the heart and share your custom itinerary with friends."
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(maxHeight: 380)
            
            Spacer()
            
            // Opção "Não mostrar novamente"
            HStack {
                Button(action: { dontShowAgain.toggle() }) {
                    Image(systemName: dontShowAgain ? "checkmark.square.fill" : "square")
                        .foregroundColor(dontShowAgain ? .purple : .gray)
                        .font(.title3)
                }
                Text(isPortuguese ? "Não mostrar esta mensagem novamente" : "Don't show this message again")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            // Botão Principal (Avançar / Concluir)
            Button(action: {
                if currentPage < 2 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    dismiss()
                    onOK()
                }
            }) {
                Text(currentPage == 2 ? (isPortuguese ? "Começar" : "Get Started") : (isPortuguese ? "Avançar" : "Next"))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 2)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Subview para cada ecrã de onboarding
struct TutorialStepView: View {
    let iconName: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 100, height: 100)
                
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundColor(iconColor)
            }
            .padding(.top, 10)
            
            Text(title)
                .font(.custom("Montserrat", size: 24).weight(.bold))
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
        }
    }
}
