

import SwiftUI
import MapKit


extension CLLocationCoordinate2D {
    static let sriLanka: Self = .init(
        latitude: 7.517242,
        longitude: 80.779494
    )
}

struct DiscoverView: View {
    @StateObject var eventViewModel = EventListViewModel()
    let manager = CLLocationManager()
    
    
    @State var cameraPosition: MapCameraPosition = .userLocation(
        fallback: .camera(
            MapCamera(centerCoordinate: .sriLanka, distance: 0)
        )
    )
    
    
    
//    let rect = MKMapRect(
//        origin: MKMapPoint(.sriLanka),
//        size: MKMapSize(width: 100, height: 100)
//    )
    
   
//    @State var cameraPosition: MapCameraPosition = 
////        .userLocation(fallback: .automatic)
//        .region(MKCoordinateRegion(center: .sriLanka, span: MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4)))
    
//    @State private var position: MapCameraPosition = .userLocation(
//           followsHeading: true,
//           fallback: .rect(rect)
//       )
//    
//    
    
    var body: some View {
        Map(position: $cameraPosition
        
        
        
        ) {
            UserAnnotation()
            ForEach(eventViewModel.events, id: \.id) { event in
                //                EventAnnotation(event: event)
                Marker(event.title, coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude))
                
            }
        }
        .mapControls{
            MapUserLocationButton()
        }
        .onAppear{
            manager.requestWhenInUseAuthorization()
            
        }
    }
}

#Preview {
    DiscoverView()
}


//                  let region = MKCoordinateRegion(center: .userLocation, span: MKCoordinateSpan(latitudeDelta: 500, longitudeDelta: 500))
//            cameraPosition = .region(region)
//                }
//            }
// func updateCameraPosition() {
//     if let userLocation = manager {
//         let userRegion = MKCoordinateRegion(
//             center: userLocation.coordinate,
//             span: MKCoordinateSpan(
//                 latitudeDelta: 0.15,
//                 longitudeDelta: 0.15
//             )
//         )
//         withAnimation {
//             cameraPosition = .region(userRegion)
//         }
//     }
// }
