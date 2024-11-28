import SwiftUI

struct MyEventsView: View {
    @StateObject var eventViewModel = EventListViewModel()
    @EnvironmentObject var authService: AuthService // To access the current user
    
    // Declare `userEvents` as a derived variable
    var userEvents: [Event] {
        eventViewModel.events.filter { $0.userId == authService.currentUser?.id }
    }

    var body: some View {
        List(userEvents) { event in
            NavigationLink {
                EventDetailsView(event: event, eventFromParent: binding(for: event))
            } label: {
                EventRow(event: event)
            }
        }
        .toolbar {
            NavigationLink(destination: AddEventView()) {
                Label("Add Event", systemImage: "plus")
            }
        }
        .navigationTitle("My Events")
        .onAppear {
            eventViewModel.fetchEvents()
        }
    }
    
    // Find a binding for the selected event
    private func binding(for event: Event) -> Binding<Event> {
        guard let index = eventViewModel.events.firstIndex(where: { $0.id == event.id }) else {
            fatalError("Event not found in array")
        }
        return $eventViewModel.events[index]
    }
}

#Preview {
    NavigationStack {
        MyEventsView()
            .environmentObject(AuthService()) // Make sure to provide the auth service
    }
}

struct EventRow: View {
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.headline)
            Text(event.city)
                .font(.subheadline)
        }
    }
}
