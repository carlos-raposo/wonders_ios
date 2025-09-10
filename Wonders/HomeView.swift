import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Home")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Color.primary)
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}
