import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String
    var loopMode: LottieLoopMode = .loop
    var speed: CGFloat = 1.0

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.clipsToBounds = true

        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.clipsToBounds = true
        animationView.backgroundColor = .clear
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            animationView.animation = LottieAnimation.filepath(path)
        }
        animationView.loopMode = loopMode
        animationView.animationSpeed = speed
        animationView.contentMode = .scaleAspectFit
        animationView.play()

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
        // No update needed for static animation
    }
}
