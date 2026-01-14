import SwiftUI
import Lottie

struct LaunchAnimationView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var languageSettings: LanguageSettings

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)

            let animationFile = languageSettings.language == "pt" ? "welcome_pt" : "welcome_animation"
            if Bundle.main.path(forResource: animationFile, ofType: "json") != nil {
                LaunchLottieView(filename: animationFile) { _ in
                    // Dismiss after animation finishes
                    DispatchQueue.main.async {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
                .frame(maxWidth: 500, maxHeight: 500)
            } else {
                // Fallback visual se o arquivo não existir
                VStack {
                    Spacer()
                    Text("Animação não encontrada: \(animationFile).json")
                        .foregroundColor(.red)
                        .font(.headline)
                    Spacer()
                }
                .onAppear {
                    // Dismiss imediatamente para não travar o app
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}

struct LaunchLottieView: UIViewRepresentable {
    var filename: String
    var loopMode: LottieLoopMode = .playOnce
    var onCompletion: ((Bool) -> Void)?

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit

        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            animationView.animation = LottieAnimation.filepath(path)
        }
        animationView.loopMode = loopMode
        animationView.play { finished in
            onCompletion?(finished)
        }

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

#if DEBUG
struct LaunchAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAnimationView(isPresented: .constant(true))
            .environmentObject(LanguageSettings())
    }
}
#endif
