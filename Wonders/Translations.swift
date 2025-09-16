import Foundation
import SwiftUI

class Translations {
    static let shared = Translations()
    let dict: [String: [String: String]] = [
        "en": [
            "miniaturas_of": "Miniatures of",
            "map": "Map",
            "open_map": "Open map of category",
            "history": "History",
            "adress": "Address",
            "map_category_title": "Category Map"
        ],
        "pt": [
            "miniaturas_of": "Miniaturas de",
            "map": "Mapa",
            "open_map": "Abrir mapa da categoria",
            "history": "História",
            "adress": "Endereço",
            "map_category_title": "Mapa da categoria"
        ]
    ]
    func t(_ key: String, lang: String) -> String {
        dict[lang]?[key] ?? dict["en"]?[key] ?? key
    }
}
