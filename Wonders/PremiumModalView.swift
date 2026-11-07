import SwiftUI
import FirebaseAuth

struct PremiumModalView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var languageSettings: LanguageSettings
    @Environment(\.colorScheme) var colorScheme
    
    var onContinueFree: (() -> Void)? = nil
    
    // Estados para autenticação
    @AppStorage("isUserLoggedIn") private var isAuthenticated = false
    @State private var showAuthModal = false
    @State private var showSignIn = false
    
    var currentLang: String {
        let lang = languageSettings.language.lowercased()
        if lang.hasPrefix("pt") { return "pt" }
        if lang.hasPrefix("fr") { return "fr" }
        if lang.hasPrefix("es") { return "es" }
        return "en"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Indicador de arrastar no topo
                Capsule()
                    .fill(Color.secondary.opacity(0.4))
                    .frame(width: 36, height: 5)
                    .padding(.top, 12)
                
                // Estrela Amarela
                Image(systemName: "star.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.yellow)
                    .padding(.top, 8)
                
                // Título
                Text(titleText)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                // Lista de Benefícios
                VStack(spacing: 8) {
                    Text(benefit1Text)
                    Text(benefit2Text)
                    Text(benefit3Text)
                    Text(benefit4Text)
                    Text(benefit5Text)
                }
                .font(.system(size: 20, weight: .light, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.vertical, 4)
                
                // Subtítulo de pagamento
                Text(paymentText)
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.top, 4)
                
                // Botão de Compra com Verificação Prévia de Autenticação
                Button(action: {
                    let userIsLoggedIn = Auth.auth().currentUser != nil
                    print("DEBUG: Botão premido. isAuthenticated = \(isAuthenticated), currentUser = \(String(describing: Auth.auth().currentUser))")
                    
                    if userIsLoggedIn {
                        isAuthenticated = true
                        print("DEBUG: A iniciar fluxo de compra...")
                        Task {
                            let success = (try? await purchaseManager.purchase()) ?? false
                            print("DEBUG: Resultado da compra: success = \(success), isPurchased = \(purchaseManager.isPurchased)")
                            if success && purchaseManager.isPurchased {
                                dismiss()
                            }
                        }
                    } else {
                        print("DEBUG: Utilizador não autenticado no Firebase. A abrir modal de auth.")
                        showAuthModal = true
                    }
                }){
                    HStack {
                        if purchaseManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text(buttonText)
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(red: 79/255, green: 123/255, blue: 159/255))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                }
                .disabled(purchaseManager.isLoading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Continuar com Versão Gratuita
                Button(action: {
                    onContinueFree?()
                    dismiss()
                }) {
                    Text(freeVersionText)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .underline()
                        .foregroundColor(.primary)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .alert(isPresented: $showAuthModal) {
            Alert(
                title: Text(authTitleText),
                message: Text(authMessageText),
                primaryButton: .default(Text(signInButtonText)) {
                    showSignIn = true
                },
                secondaryButton: .cancel(Text("X"))
            )
        }
        .sheet(isPresented: $showSignIn) {
            LoginView(onAuthenticated: {
                isAuthenticated = true
                showSignIn = false
            })
            .environmentObject(languageSettings)
        }
        .onChange(of: showSignIn) { isShowing in
            if !isShowing && Auth.auth().currentUser != nil {
                isAuthenticated = true
            }
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                isAuthenticated = true
            }
        }
    }
    
    // MARK: - Traduções de Autenticação
    
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
        case "pt": return "Faça login para efetuar compras."
        case "fr": return "Veuillez vous connecter pour effectuer des achats."
        case "es": return "Inicia sesión para realizar compras."
        default: return "Please log in to make purchases."
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
    
    // MARK: - Traduções Dinâmicas Existentes
    
    var titleText: String {
        switch currentLang {
        case "pt": return "Desbloquear Guia Completo"
        case "fr": return "Débloquer le guide complet"
        case "es": return "Desbloquear guía completa"
        default: return "Unlock Full Guide"
        }
    }
    
    var benefit1Text: String {
        switch currentLang {
        case "pt": return "Enriqueça a sua experiência"
        case "fr": return "Enrichissez votre expérience"
        case "es": return "Enriquece tu experiencia"
        default: return "Take your experience further"
        }
    }
    
    var benefit2Text: String {
        switch currentLang {
        case "pt": return "Ouça narrações de áudio completas para todos os locais e experiências"
        case "fr": return "Écoutez des narrations audio complètes pour tous les lieux et expériences"
        case "es": return "Escucha narraciones de audio completas para todos los lugares y experiencias"
        default: return "Listen to full audio narrations for all places and experiences"
        }
    }
    
    var benefit3Text: String {
        switch currentLang {
        case "pt": return "Aceda a histórias completas"
        case "fr": return "Accédez à des histoires complètes"
        case "es": return "Accede a historias completas"
        default: return "Access complete stories"
        }
    }
    
    var benefit4Text: String {
        switch currentLang {
        case "pt": return "Obtenha dicas exclusivas"
        case "fr": return "Obtenez des conseils exclusifs"
        case "es": return "Obtén consejos exclusivos"
        default: return "Get exclusive tips"
        }
    }
    
    var benefit5Text: String {
        switch currentLang {
        case "pt": return "Descarregue offline para explorar a cidade sem usar dados móveis."
        case "fr": return "Téléchargez hors ligne pour explorer la ville sans utiliser de données mobiles."
        case "es": return "Descarga sin conexión para explorar la ciudad sin usar datos mobiles."
        default: return "Download offline to explore the city without using mobile data."
        }
    }
    
    var paymentText: String {
        switch currentLang {
        case "pt": return "Pagamento único • Válido por 1 ano"
        case "fr": return "Paiement unique • Valable 1 an"
        case "es": return "Pago único • Válido por 1 año"
        default: return "Single payment • Valid for 1 year"
        }
    }
    
    var buttonText: String {
        let price = purchaseManager.products.first?.displayPrice ?? "9,99 €"
        switch currentLang {
        case "pt": return "Desbloquear por \(price)"
        case "fr": return "Débloquer pour \(price)"
        case "es": return "Desbloquear por \(price)"
        default: return "Unlock for \(price)"
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
}
