import SwiftUI

// MARK: - Modificadores de Estilo Airbnb
extension Font {
    /// Título de Secção (ex: "Destinations for you")
    static var airbnbSectionTitle: Font {
        .system(size: 22, weight: .regular, design: .rounded)
    }
    
    /// Título de Cartão/Item fixo (ex: "Shared room in Porto")
    static var airbnbItemTitle: Font {
        .system(size: 16, weight: .regular, design: .rounded)
    }
    
    /// Título de Cartão/Item com tamanho flexível (ex: para iPad ou ecrãs maiores)
    static func airbnbItemTitle(size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
    
    /// Corpo de Texto / Leitura longa (ex: Histórias, Descrições)
    static var airbnbBody: Font {
        .system(size: 18, weight: .light, design: .rounded)
    }
    
    /// Subtítulo / Legenda (ex: "Epic architecture")
    static var airbnbSubtitle: Font {
        .system(size: 14, weight: .regular, design: .default)
    }
    
    /// Preço / Destaques em Texto
    static var airbnbPrice: Font {
        .system(size: 14, weight: .semibold, design: .rounded)
    }
    
    /// Etiquetas e Badges (ex: "Guest favourite")
    static var airbnbBadge: Font {
        .system(size: 13, weight: .bold, design: .rounded)
    }
    
    /// Rótulos da TabBar
    static var airbnbTabLabel: Font {
        .system(size: 10, weight: .semibold, design: .rounded)
    }
    
    /// Estilo para botões e opções de definições / perfil (18pt, Regular, Rounded)
    static var airbnbSettingsLabel: Font {
        .system(size: 20, weight: .light, design: .rounded)
    }
    
}
