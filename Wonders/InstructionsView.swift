import SwiftUI

struct InstructionsView: View {
    @State private var dontShowAgain = false
    var onOK: () -> Void = {}
    var body: some View {
        VStack(spacing: 24) {
            Text("Bem-vindo de volta")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            Text("Explore as maravilhas de Lisboa na app e organize com antecedência a sua visita.")
                .font(.body)
                .multilineTextAlignment(.leading)
            VStack(alignment: .leading, spacing: 8) {
                Text("Estas são as instruções para usar a app:")
                    .font(.body)
                    .fontWeight(.bold)
                Text("As 7 Maravilhas estão organizadas por categorias, cada uma com 7 destaques imperdíveis, além de uma oitava opção para outros pontos de interesse que merecem a sua atenção.")
                    .font(.body)
                HStack(alignment: .top) {
                    Image(systemName: "heart")
                        .foregroundColor(.purple)
                    Text("Favoritos: Marque os seus locais preferidos com o ícone 'favoritos' e crie a sua lista personalizada.")
                        .font(.body)
                }
                HStack(alignment: .top) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.purple)
                    Text("Partilhar: Partilhe a sua lista de favoritos com amigos e familiares, ou ...")
                        .font(.body)
                }
            }
            Spacer()
            Button(action: onOK) {
                Text("OK")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 2)
            }
            HStack {
                Button(action: { dontShowAgain.toggle() }) {
                    Image(systemName: dontShowAgain ? "checkmark.square" : "square")
                        .foregroundColor(.gray)
                }
                Text("Não mostrar esta mensagem novamente")
                    .font(.body)
            }
            .padding(.bottom)
        }
        .padding()
    }
}
