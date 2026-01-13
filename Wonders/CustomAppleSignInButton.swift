import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore

final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    var currentNonce: String
    var completion: (Result<ASAuthorizationAppleIDCredential, Error>) -> Void
    init(nonce: String, completion: @escaping (Result<ASAuthorizationAppleIDCredential, Error>) -> Void) {
        self.currentNonce = nonce
        self.completion = completion
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            completion(.success(credential))
        } else {
            completion(.failure(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credential"])) )
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion(.failure(error))
    }
}

struct CustomAppleSignInButton: View {
    var onAuthenticated: () -> Void
    @Binding var errorMessage: String?
    @State private var delegateHolder: AppleSignInDelegate? = nil

    var body: some View {
        Button(action: startSignIn) {
            HStack {
                Image(systemName: "applelogo")
                    .foregroundColor(.black)
                Text("Iniciar sessão com a Apple")
                    .foregroundColor(.black)
                    .font(.headline)
            }
        }
    }

    func startSignIn() {
        let nonce = randomNonceString()
        // store locally to send to firebase
        let currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let delegate = AppleSignInDelegate(nonce: currentNonce) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let credential):
                    guard let identityToken = credential.identityToken,
                          let authorizationCode = credential.authorizationCode,
                          let idTokenString = String(data: identityToken, encoding: .utf8),
                          let accessTokenString = String(data: authorizationCode, encoding: .utf8) else {
                        self.errorMessage = "Erro ao obter token do Apple."
                        return
                    }
                    // Use helper if exists; else build credential via OAuthProvider
                    let firebaseCredential = AppleAuthHelper.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: currentNonce, accessToken: accessTokenString)
                    Auth.auth().signIn(with: firebaseCredential) { authResult, error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            return
                        }
                        guard let authResult = authResult else {
                            self.errorMessage = "Erro desconhecido ao autenticar."
                            return
                        }
                        // create user doc if needed
                        let db = Firestore.firestore()
                        let userRef = db.collection("users").document(authResult.user.uid)
                        userRef.getDocument { document, error in
                            if let document = document, document.exists {
                                self.errorMessage = nil
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
                                        self.errorMessage = error.localizedDescription
                                    } else {
                                        self.errorMessage = nil
                                        onAuthenticated()
                                    }
                                }
                            }
                        }
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                // release delegate
                self.delegateHolder = nil
            }
        }
        self.delegateHolder = delegate
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = delegate
        controller.performRequests()
    }
}
