import SwiftUI

struct LaunchAnimationView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var languageSettings: LanguageSettings

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)

            let animationFile = languageSettings.language == "pt" ? "welcome_animation_pt" : "welcome_animation"

            // Verificação da existência do ficheiro .lottie no Bundle
            if Bundle.main.path(forResource: animationFile, ofType: "lottie") != nil {
                LottieView(filename: animationFile, loopMode: .playOnce) { _ in
                    // Dismiss suave após a animação terminar
                    DispatchQueue.main.async {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
                .frame(maxWidth: 500, maxHeight: 500)
            } else {
                // Fallback visual caso o ficheiro .lottie não esteja no Bundle
                VStack {
                    Spacer()
                    Text("Animação não encontrada: \(animationFile).lottie")
                        .foregroundColor(.red)
                        .font(.headline)
                    Spacer()
                }
                .onAppear {
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

#if DEBUG
struct LaunchAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAnimationView(isPresented: .constant(true))
            .environmentObject(LanguageSettings())
    }
}
#endif
