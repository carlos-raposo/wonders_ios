import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String
    var loopMode: LottieLoopMode = .playOnce
    var speed: CGFloat = 1.0
    var onCompletion: ((Bool) -> Void)? = nil

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit

        // --- CARREGAMENTO DO FICHEIRO .DOTLOTTIE ---
        DotLottieFile.named(filename) { result in
            switch result {
            case .success(let dotLottie):
                animationView.loadAnimation(from: dotLottie)
                animationView.loopMode = loopMode
                animationView.animationSpeed = speed
                animationView.play { finished in
                    onCompletion?(finished)
                }
                print("✅ [LottieView] Sucesso ao carregar .dotLottie: \(filename)")
            case .failure(let error):
                print("❌ [LottieView] Erro ao carregar .dotLottie '\(filename)': \(error)")
            }
        }
        // -------------------------------------------

        container.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: container.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: container.heightAnchor),
            animationView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No-op
    }
}
