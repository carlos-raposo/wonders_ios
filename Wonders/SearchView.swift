import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack {
            Text("Search Screen")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
