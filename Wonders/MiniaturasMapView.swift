import SwiftUI
import MapKit

struct MiniaturaLocation: Identifiable {
    let id = UUID()
    let title: String
    let latitude: Double
    let longitude: Double
    let ordem: Int
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MiniaturasMapView: View {
    let locations: [MiniaturaLocation]
    let mapTitle: String
    let showNumbers: Bool // controls whether to show numbers in markers
    let zoomSpan: MKCoordinateSpan // NEW: allows custom zoom per map
    let customCenter: CLLocationCoordinate2D? // Corrigido: sem valor default
    @Environment(\.presentationMode) var presentationMode

    // Center map on customCenter, first location, or Lisbon if none
    var region: MKCoordinateRegion {
        if let custom = customCenter {
            return MKCoordinateRegion(center: custom, span: zoomSpan)
        } else if let first = locations.first {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude),
                span: zoomSpan
            )
        } else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 38.7223, longitude: -9.1393), // Lisbon
                span: zoomSpan
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
                Map(coordinateRegion: .constant(region), interactionModes: .all, showsUserLocation: false, annotationItems: locations) { loc in
                    MapAnnotation(coordinate: loc.coordinate) {
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
                                        .foregroundColor(.red) // Red circle marker
                                    if showNumbers {
                                        if loc.ordem == 8 {
                                            Text("+")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white) // White number
                                        } else {
                                            Text("\(loc.ordem)")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white) // White number
                                        }
                                    }
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
