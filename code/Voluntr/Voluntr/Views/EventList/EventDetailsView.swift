import MapKit
import SwiftUI
import FirebaseAuth

struct EventDetailsView: View {
    @State var event: Event
    @Binding var eventFromParents: Event
    @StateObject var eventViewModel = EventListViewModel()
    @State private var isEditing = false
    @State private var editedEvent: Event
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the view

    init(event: Event, eventFromParent: Binding<Event>? = nil) {
        self.event = event
        _editedEvent = State(initialValue: event) // Initialize with the current event
        if((eventFromParent) != nil) {
            _eventFromParents = eventFromParent!
        } else {
            _eventFromParents = .constant(event)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                if isEditing {
                    TextField("Title", text: $editedEvent.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                } else {
                    Text(event.title)
                        .font(.title)
                        .fontWeight(.bold)
                }

                Divider()

                // Event Details
                Group {
                    detailRow(icon: "calendar", title: "Date", value: dateString(from: event.date.dateValue()))
                    detailRow(icon: "clock", title: "Start Time", value: timeString(from: event.date.dateValue()))

                    HStack {
                        Image(systemName: "location")
                        Text("Location:")
                            .fontWeight(.bold)
                        if isEditing {
                            TextField("Location", text: $editedEvent.city)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        } else {
                            Text(event.city)
                        }
                    }

                    detailRow(icon: "person.3", title: "Participants", value: "\(event.participants.count + 1)")
                    detailRow(icon: "person.3.fill", title: "Max Participants", value: "\(event.availableSlots)")

                    HStack {
                        Image(systemName: "clock")
                        Text("Duration:")
                            .fontWeight(.bold)
                        if isEditing {
                            TextField("Duration", value: $editedEvent.duration, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        } else {
                            Text("\(event.duration) hrs")
                        }
                    }
                }

                Divider()

                // Event Description
                if isEditing {
                    TextField("Description", text: $editedEvent.description)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                } else {
                    Text(event.description)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }

                Divider()

                // Map displaying the event's location
                Map {
                    Marker(
                        event.title,
                        coordinate: CLLocationCoordinate2D(
                            latitude: event.location.latitude,
                            longitude: event.location.longitude))
                }
                .frame(height: 200)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )

                // Buttons Section
                if event.userId == Auth.auth().currentUser?.uid {
                    if isEditing {
                        saveChangesButton
                    } else {
                        editButton
                    }

                    deleteButton
                } else {
                    joinEventButton
                }
            }
            .padding()
        }
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            eventViewModel.fetchEvents()
        }
    }

    // MARK: - UI Components
    func detailRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text("\(title):")
                .fontWeight(.bold)
            Text(value)
        }
    }

    var editButton: some View {
        Button(action: {
            isEditing = true
        }) {
            Text("Edit Event")
                .font(.headline)
                .foregroundColor(Color(red: 200 / 255, green: 182 / 255, blue: 255 / 255))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }

    var saveChangesButton: some View {
        Button(action: {
            updateEvent(event: editedEvent)
        }) {
            Text("Save Changes")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 200 / 255, green: 182 / 255, blue: 255 / 255).opacity(0.6))
                .cornerRadius(10)
        }
    }

    var deleteButton: some View {
        Button(action: {
            deleteEvent(event: event)
        }) {
            Text("Delete Event")
                .font(.headline)
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }

    var joinEventButton: some View {
        Button(action: {
            EventService.joinEvent(event: event) { error in
                if let error = error {
                    print("Error joining event: \(error.localizedDescription)")
                } else {
                    print("Successfully joined event")
                    eventViewModel.fetchEvents() // Refresh events after joining
                }
            }
        }) {
            Label("Join Event", systemImage: "person.crop.circle.badge.plus")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 200 / 255, green: 182 / 255, blue: 255 / 255).opacity(0.6))
                .cornerRadius(10)
        }
    }

    // MARK: - Helpers
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }

    // MARK: - Event Actions
    func updateEvent(event: Event) {
        self.event = event
        eventFromParents = event
        EventService.updateEvent(event: event) { error in
            if let error = error {
                print("Error updating event: \(error.localizedDescription)")
            } else {
                print("Event updated successfully")
                isEditing = false
                eventViewModel.fetchEvents()
            }
        }
    }

    func deleteEvent(event: Event) {
        EventService.deleteEvent(event: event) { error in
            if let error = error {
                print("Error deleting event: \(error.localizedDescription)")
            } else {
                print("Event deleted successfully")
                eventViewModel.fetchEvents()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
