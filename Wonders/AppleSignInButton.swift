import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import CryptoKit
import Foundation

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    return result
}

struct SignInWithAppleButtonView: View {
    var onAuthenticated: () -> Void
    @Binding var errorMessage: String?
    @State private var currentNonce: String = ""
    var body: some View {
        SignInWithAppleButtonInternal { result in
            switch result {
            case .success(let credential):
                guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential,
                      let identityToken = appleIDCredential.identityToken,
                      let authorizationCode = appleIDCredential.authorizationCode,
                      let idTokenString = String(data: identityToken, encoding: .utf8),
                      let accessTokenString = String(data: authorizationCode, encoding: .utf8) else {
                    errorMessage = "Erro ao obter token do Apple."
                    return
                }
                guard let firebaseCredential = AppleAuthHelper.credential(withProviderID: "apple.com", idToken: idTokenString, accessToken: accessTokenString) else {
                    errorMessage = "Erro ao criar credential do Firebase."
                    return
                }
                Auth.auth().signIn(with: firebaseCredential) { authResult, error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else if let authResult = authResult {
                        let db = Firestore.firestore()
                        let userRef = db.collection("users").document(authResult.user.uid)
                        userRef.getDocument { document, error in
                            if let document = document, document.exists {
                                errorMessage = nil
                                onAuthenticated()
                            } else {
                                userRef.setData([
                                    "name": authResult.user.displayName ?? "",
                                    "email": authResult.user.email ?? "",
                                    "createdAt": FieldValue.serverTimestamp(),
                                    "lastLogin": FieldValue.serverTimestamp(),
                                    "authProvider": "apple",
                                    "photoURL": authResult.user.photoURL?.absoluteString ?? ""
                                ]) { error in
                                    if let error = error {
                                        errorMessage = error.localizedDescription
                                    } else {
                                        errorMessage = nil
                                        onAuthenticated()
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        } onRequest: { request in
            let nonce = randomNonceString()
            currentNonce = nonce
            request.nonce = sha256(nonce)
            request.requestedScopes = [.fullName, .email]
        }
        .frame(height: 50)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

struct SignInWithAppleButtonInternal: UIViewRepresentable {
    var completion: (Result<ASAuthorizationCredential, Error>) -> Void
    var onRequest: ((ASAuthorizationAppleIDRequest) -> Void)? = nil
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.didTapButton), for: .touchUpInside)
        return button
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion, onRequest: onRequest)
    }
    class Coordinator: NSObject, ASAuthorizationControllerDelegate {
        let completion: (Result<ASAuthorizationCredential, Error>) -> Void
        let onRequest: ((ASAuthorizationAppleIDRequest) -> Void)?
        init(completion: @escaping (Result<ASAuthorizationCredential, Error>) -> Void, onRequest: ((ASAuthorizationAppleIDRequest) -> Void)? = nil) {
            self.completion = completion
            self.onRequest = onRequest
        }
        @objc func didTapButton() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            onRequest?(request)
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                completion(.success(credential))
            }
        }
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            completion(.failure(error))
        }
    }
}
