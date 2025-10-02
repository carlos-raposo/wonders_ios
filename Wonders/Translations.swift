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
            "map_category_title": "Map",
            "Churches": "Churches",
            "Monuments": "Monuments",
            "Museums": "Museums",
            "Nature": "Nature",
            "Gastronomy": "Gastronomy",
            "Popular": "Popular",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulary"
        ],
        "pt": [
            "miniaturas_of": "Miniaturas de",
            "map": "Mapa",
            "open_map": "Abrir mapa da categoria",
            "history": "História",
            "adress": "Endereço",
            "map_category_title": "Mapa de",
            "Churches": "Igrejas",
            "Monuments": "Monumentos",
            "Museums": "Museus",
            "Nature": "Natureza",
            "Gastronomy": "Gastronomia",
            "Popular": "Popular",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulário"
        ]
    ]
    func t(_ key: String, lang: String) -> String {
        dict[lang]?[key] ?? dict["en"]?[key] ?? key
    }
}
