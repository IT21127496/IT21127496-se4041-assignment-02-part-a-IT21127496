

import FirebaseFirestore
import MapKit
import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authService: AuthService
    @StateObject var eventViewModel = EventListViewModel()
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var eventDate: Date = Date()
    @State private var city: String = ""
    @State private var numberOfSlots: Int = 0
    @State private var duration: Int = 1
    
    @State private var showAlert = false
    @State private var alertMessage = "Please fill in all required fields."
    
    let selectedCoordinates = CLLocationCoordinate2D(latitude: 25.865208, longitude: -80.121807)
    
    var body: some View {
        Form {
            Section("Overview") {
                TextField("Event Title", text: $title)
                
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.footnote)
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
            }
            Section("Event Details") {
                DatePicker("Date", selection: $eventDate, in: Date()..., displayedComponents: .date)
                
                DatePicker("Start Time", selection: $eventDate, displayedComponents: .hourAndMinute)
                
                HStack {
                    Text("Duration:")
                    Spacer()
                    Stepper(value: $duration, in: 1...24) {
                        Text("\(duration) hour(s)")
                    }
                }
            }
            
            Section("Available Slots") {
                HStack {
                    Stepper(value: $numberOfSlots, in: 0...10) {
                        Text("Slots: \(numberOfSlots)")
                            .font(.headline)
                    }
                    .labelsHidden()
                    
                    Spacer()
                    
                    TextField("Number of slots", value: $numberOfSlots, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                }
            }
            
            Section("Location") {
                TextField("City", text: $city)
                Map(interactionModes: MapInteractionModes()) {
                    Marker("Selected Location", coordinate: selectedCoordinates)
                }
                .frame(height: 200)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            
            Button(action: {
                guard !title.isEmpty, !description.isEmpty, !city.isEmpty, numberOfSlots != 0
                else {
                    alertMessage = "Please fill in all required fields."
                    showAlert = true
                    return
                }
                
                print("Event added with title: \(title)")
                EventService.createEvent(
                    event: Event(
                        title: title, description: description, date: Timestamp(date: eventDate),
                        location: GeoPoint(
                            latitude: selectedCoordinates.latitude,
                            longitude: selectedCoordinates.longitude
                        ),
                        userId: authService.currentUser?.id ?? "",
                        participants: [],
                        duration: duration, city: city, availableSlots: numberOfSlots
                    )
                ) { error in
                    if let error = error {
                        alertMessage = "Error adding event"
                        showAlert = true
                        print("Error adding event: \(error.localizedDescription)")
                    } else {
                        eventViewModel.fetchEvents()
                        print("Event added successfully")
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text("Add Event")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Missing Information"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarTitle("Add New Event", displayMode: .inline)
    }
}

#Preview {
    AddEventView().environmentObject(AuthService())
}
