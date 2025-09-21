import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: Set<String> = []
    private var listener: ListenerRegistration?
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    private var db: Firestore {
        Firestore.firestore()
    }

    init() {
        observeFavorites()
    }

    deinit {
        listener?.remove()
    }

    func isFavorite(card: MiniaturaCard) -> Bool {
        favorites.contains(favoriteKey(for: card))
    }

    func toggleFavorite(card: MiniaturaCard) {
        guard let uid = userId else { return }
        let favKey = favoriteKey(for: card)
        let userRef = db.collection("users").document(uid)
        if favorites.contains(favKey) {
            favorites.remove(favKey)
            userRef.updateData([
                "favorites": FieldValue.arrayRemove([favKey])
            ])
        } else {
            favorites.insert(favKey)
            userRef.setData([
                "favorites": FieldValue.arrayUnion([favKey])
            ], merge: true)
        }
    }

    func clearFavorites() {
        guard let uid = userId else { return }
        favorites.removeAll()
        let userRef = db.collection("users").document(uid)
        userRef.updateData(["favorites": []])
    }

    private func favoriteKey(for card: MiniaturaCard) -> String {
        "\(card.id)"
    }

    private func observeFavorites() {
        guard let uid = userId else { return }
        listener?.remove()
        let userRef = db.collection("users").document(uid)
        listener = userRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            if let data = snapshot?.data(), let favs = data["favorites"] as? [String] {
                self.favorites = Set(favs)
            } else {
                self.favorites = []
            }
        }
    }

    func refreshFavorites() {
        observeFavorites()
    }
}
