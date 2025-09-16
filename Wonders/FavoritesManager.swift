import Foundation
import Combine

class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: Set<String> = []
    private let key = "favoritesMiniaturas"
    
    init() {
        load()
    }
    
    func isFavorite(card: MiniaturaCard) -> Bool {
        favorites.contains(favoriteKey(for: card))
    }
    
    func toggleFavorite(card: MiniaturaCard) {
        let favKey = favoriteKey(for: card)
        if favorites.contains(favKey) {
            favorites.remove(favKey)
            print("[FavoritesManager] Removed favorite: \(favKey)")
        } else {
            favorites.insert(favKey)
            print("[FavoritesManager] Added favorite: \(favKey)")
        }
        save()
        print("[FavoritesManager] Current favorites: \(favorites)")
    }
    
    func clearFavorites() {
        favorites.removeAll()
        UserDefaults.standard.removeObject(forKey: key)
        print("[FavoritesManager] All favorites cleared.")
    }
    
    private func favoriteKey(for card: MiniaturaCard) -> String {
        "\(card.id)"
    }
    
    private func load() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            favorites = Set(saved)
            print("[FavoritesManager] Loaded favorites: \(favorites)")
        } else {
            print("[FavoritesManager] No favorites found in UserDefaults.")
        }
    }
    
    private func save() {
        UserDefaults.standard.set(Array(favorites), forKey: key)
    }
}
