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
            "Vocabulary": "Vocabulary",
            "highlights": "Highlights",
            "usage": "Usage",
            "choose_category": "Choose a Category",
            "search": "Search",
            "pronunciation": "Pronunciation",
            "settings": "Settings",
            "language": "Language"
            
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
            "Vocabulary": "Vocabulário",
            "highlights": "Destaques",
            "usage": "Uso",
            "pronunciation": "Pronúncia",
            "choose_category": "Escolha uma Categoria",
            "search": "Pesquisar",
            "settings": "Configurações",
            "language": "Idioma"
            
        ],
        "fr": [
            "miniaturas_of": "Miniatures de",
            "map": "Carte",
            "open_map": "Ouvrir la carte de la catégorie",
            "history": "Histoire",
            "adress": "Adresse",
            "map_category_title": "Carte de",
            "Churches": "Églises",
            "Monuments": "Monuments",
            "Museums": "Musées",
            "Nature": "Nature",
            "Gastronomy": "Gastronomie",
            "Popular": "Populaire",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulaire",
            "highlights": "Les incontournables",
            "usage": "Utilisation",
            "pronunciation": "Prononciation",
            "choose_category": "Choisissez une catégorie",
            "search": "Rechercher",
            "settings": "Paramètres",
            "language": "Langue"
        ],
            "es": [
            "miniaturas_of": "Miniaturas de",
            "map": "Mapa",
            "open_map": "Abrir mapa de la categoría",
            "history": "Historia",
            "adress": "Dirección",
            "map_category_title": "Mapa de",
            "Churches": "Iglesias",
            "Monuments": "Monumentos",
            "Museums": "Museos",
            "Nature": "Naturaleza",
            "Gastronomy": "Gastronomía",
            "Popular": "Popular",
            "Sintra": "Sintra",
            "Vocabulary": "Vocabulario",
            "highlights": "Destacados",
            "usage": "Uso",
            "pronunciation": "Pronunciación",
            "choose_category": "Elija una categoría",
            "search": "Buscar",
            "settings": "Configuración",
            "language": "Idioma"
        ]
    ]
    func t(_ key: String, lang: String) -> String {
        dict[lang]?[key] ?? dict["en"]?[key] ?? key
    }
}
