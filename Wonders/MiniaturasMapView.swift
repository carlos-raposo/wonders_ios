import SwiftUI
import MapKit

struct MiniaturaLocation: Identifiable {
    let id = UUID()
    let title: String
    let latitude: Double
    let longitude: Double
    let ordem: Int
}

struct MiniaturasMapView: View {
    let locations: [MiniaturaLocation]
    let mapTitle: String
    @Environment(\.presentationMode) var presentationMode

    // Center map on first location, or Lisbon if none
    var region: MKCoordinateRegion {
        if let first = locations.first {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
            )
        } else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 38.7223, longitude: -9.1393), // Lisbon
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(8)
                }
                Spacer()
                Text(mapTitle)
                    .font(.headline)
                    .padding(.trailing, 16)
                Spacer(minLength: 0)
            }
            .background(.ultraThinMaterial)
            .padding(.bottom, 2)
            if locations.isEmpty {
                Spacer()
                Text("No locations available")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            } else {
                Map(coordinateRegion: .constant(region), annotationItems: locations) { loc in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)) {
                        VStack(spacing: 2) {
                            Button(action: {
                                let urlString = "http://maps.apple.com/?daddr=\(loc.latitude),\(loc.longitude)"
                                if let url = URL(string: urlString) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.red)
                                    Text("\(loc.ordem)")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel("Mostrar direções para \(loc.title)")
                            Text(loc.title)
                                .font(.caption)
                                .padding(4)
                                .background(.ultraThinMaterial)
                                .cornerRadius(6)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
