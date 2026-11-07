import Foundation
import StoreKit
import FirebaseAuth
import FirebaseFirestore

@MainActor
class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    // Atualizado para o ID correto criado no App Store Connect
    let premiumProductID = "com.carlosraposo.lisbon7wonders.annual"
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var isPurchased: Bool = false
    @Published private(set) var expirationDate: Date? = nil
    @Published var isLoading: Bool = false
    @Published var redemptionErrorMessage: String? = nil
    
    private var updatesTask: Task<Void, Never>? = nil

    init() {
        updatesTask = listenForTransactions()
        
        Task {
            await fetchProducts()
            await updatePurchaseStatus()
        }
    }

    deinit {
        updatesTask?.cancel()
    }

    // MARK: - 1. Verificar Estado Geral de Compras
    func updatePurchaseStatus() async {
        // SEGURANÇA: Se não houver utilizador autenticado, o estado é obrigatoriamente gratuito
        guard Auth.auth().currentUser != nil else {
            await MainActor.run {
                self.isPurchased = false
                self.expirationDate = nil
            }
            return
        }
        
        var foundValidTransaction = false
        
        // A) Verificar StoreKit (App Store local / Transações ativas)
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try Self.checkVerified(result)
                if transaction.productID == premiumProductID {
                    foundValidTransaction = true
                    await MainActor.run {
                        self.isPurchased = true
                    }
                    await syncPurchaseToFirestore()
                    return
                }
            } catch {
                print("Transação inválida: \(error)")
            }
        }
        
        // B) Se o StoreKit NÃO tem nenhuma transação ativa, verificamos o Firestore
        if !foundValidTransaction {
            await checkUserFirestoreStatus()
        }
    }

    // MARK: - 2. Consultar o Firestore (com validação de expiração)
    func checkUserFirestoreStatus() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.isPurchased = false
            self.expirationDate = nil
            return
        }
        
        let db = Firestore.firestore()
        do {
            let document = try await db.collection("users").document(uid).getDocument()
            if let data = document.data() {
                if let timestamp = data["premiumUntil"] as? Timestamp {
                    let expDate = timestamp.dateValue()
                    self.expirationDate = expDate
                    self.isPurchased = Date() < expDate
                } else {
                    self.expirationDate = nil
                    let isPrem = (data["isPurchased"] as? Bool) ?? (data["isPremium"] as? Bool) ?? false
                    self.isPurchased = isPrem
                }
            } else {
                self.isPurchased = false
                self.expirationDate = nil
            }
        } catch {
            print("Erro ao ler estatuto Premium no Firestore: \(error)")
            self.isPurchased = false
            self.expirationDate = nil
        }
    }

    // MARK: - 3. Registar Acesso Premium de 365 Dias no Firestore (Compra In-App)
    func syncPurchaseToFirestore() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        let now = Date()
        let expDate = Calendar.current.date(byAdding: .day, value: 365, to: now) ?? now
        self.expirationDate = expDate
        
        try? await db.collection("users").document(uid).setData([
            "isPurchased": true,
            "isPremium": true,
            "purchasedAt": FieldValue.serverTimestamp(),
            "premiumUntil": Timestamp(date: expDate),
            "unlockedAt": FieldValue.serverTimestamp()
        ], merge: true)
    }

    // MARK: - 4. Processo de Compra In-App Nativa (StoreKit)
    func purchase() async throws -> Bool {
        guard Auth.auth().currentUser != nil else {
            print("Tentativa de compra bloqueada: Utilizador não autenticado no Firebase.")
            return false
        }
        
        // --- ADICIONA ESTE PRINT DE DIAGNÓSTICO ---
        print("Produtos disponíveis no PurchaseManager: \(products.map { $0.id })")
        // ------------------------------------------
        
        guard let product = products.first(where: { $0.id == premiumProductID }) else {
            print("ERRO: Produto com ID \(premiumProductID) não foi encontrado na lista de produtos carregados!")
            return false
        }
        
        isLoading = true
        let result = try await product.purchase()
        isLoading = false
        
        switch result {
        case .success(let verification):
            let transaction = try Self.checkVerified(verification)
            await transaction.finish()
            self.isPurchased = true
            await syncPurchaseToFirestore()
            return true
            
        case .userCancelled, .pending:
            return false
            
        @unknown default:
            return false
        }
    }

    // MARK: - 5. Carregar Produtos da App Store
    func fetchProducts() async {
        do {
            isLoading = true
            let storeProducts = try await Product.products(for: [premiumProductID])
            self.products = storeProducts
            isLoading = false
        } catch {
            print("Erro ao carregar produtos: \(error)")
            isLoading = false
        }
    }

    // MARK: - 6. Restaurar Compras
    func restorePurchases() async {
        isLoading = true
        try? await AppStore.sync()
        await updatePurchaseStatus()
        isLoading = false
    }

    // MARK: - Auxiliares de Validação de Transação
    nonisolated private static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try Self.checkVerified(result)
                    await transaction.finish()
                    await self.updatePurchaseStatus()
                } catch {
                    print("Falha ao validar transação em segundo plano.")
                }
            }
        }
    }
}
