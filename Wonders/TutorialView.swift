import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Text("A App permite explorar as maravilhas de Lisboa e organizar com antecedência a sua visita.")
                    .font(.body)
                    .foregroundColor(.primary)
                Text("Estas são as instruções para usar a app:")
                    .font(.body)
                    .foregroundColor(.primary)
                Text("As 7 Maravilhas estão organizadas por categorias, cada uma com 7 destaques imperdíveis, além de uma oitava opção para outros pontos de interesse que merecem a sua atenção.")
                    .font(.body)
                    .foregroundColor(.primary)
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "heart")
                            .font(.title2)
                            .foregroundColor(.red)
                        Text("FAVORITOS: Marque os seus locais preferidos com o ícone \"favoritos\" e crie a sua lista personalizada.")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("PARTILHA: Partilhe a sua lista de favoritos com amigos e familiares, ou guarde-a para si, através do ícone \"partilha\".")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "map")
                            .font(.title2)
                            .foregroundColor(.green)
                        Text("MAPA: Encontre a localização exata de cada maravilha no mapa, com o ícone \"mapa\".")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                Spacer()
                Button(action: { dismiss() }) {
                    Text("Fechar")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
            }
            .padding()
            .navigationTitle("Tutorial")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TutorialView()
}
