import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import os

class FavoritesManager: ObservableObject {
    @Published var favorites: [String] = [] // Array ordenado para preservar a ordem dos favoritos
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
        
        if let index = favorites.firstIndex(of: favKey) {
            favorites.remove(at: index)
            userRef.updateData([
                "favorites": FieldValue.arrayRemove([favKey])
            ])
        } else {
            favorites.append(favKey) // Adiciona ao fim da lista ordenada
            userRef.updateData([
                "favorites": FieldValue.arrayUnion([favKey])
            ])
        }
    }

    // Função para mover itens na grelha 2D (suporta linhas incompletas e adaptáveis)
        func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
            guard sourceIndex >= 0, sourceIndex < favorites.count,
                  sourceIndex != destinationIndex else { return }
            
            // Garante que o índice de destino respeita os limites do array
            let targetIndex = min(max(0, destinationIndex), favorites.count - 1)
            
            let item = favorites.remove(at: sourceIndex)
            favorites.insert(item, at: targetIndex)
            saveFavoritesOrder()
        }

    private func saveFavoritesOrder() {
        guard let uid = userId else { return }
        let userRef = db.collection("users").document(uid)
        userRef.setData(["favorites": favorites], merge: true) { error in
            if let error = error {
                os_log("[FavoritesManager] Erro ao guardar ordem dos favoritos: %{public}@", log: .default, type: .error, error.localizedDescription)
            }
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
            if let error = error {
                os_log("[FavoritesManager] Firestore listener error: %{public}@", log: .default, type: .error, error.localizedDescription)
                self.favorites = []
                return
            }
            if let data = snapshot?.data(), let favs = data["favorites"] as? [String] {
                self.favorites = favs
            } else {
                self.favorites = []
            }
        }
    }

    func refreshFavorites() {
        observeFavorites()
    }
}
