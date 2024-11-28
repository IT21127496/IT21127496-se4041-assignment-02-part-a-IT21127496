
import Foundation


class EventListViewModel: ObservableObject {
    @Published var events = [Event]()
    
    init() {
        fetchEvents()
    }
    
    /// Fetch all events from Firestore
    func fetchEvents() {
        EventService.fetchEvents { events in
            DispatchQueue.main.async {
                self.events = events
            }
        }
    }
    
    /// Remove a specific event from the local list
    func removeEvent(withId eventId: String) {
        DispatchQueue.main.async {
            self.events.removeAll { $0.id == eventId }
        }
    }
    
    /// Update an event in the local list
    func updateEvent(_ updatedEvent: Event) {
        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
            DispatchQueue.main.async {
                self.events[index] = updatedEvent
            }
        }
    }
    
    /// Add a new event to the local list
    func addEvent(_ newEvent: Event) {
        DispatchQueue.main.async {
            self.events.append(newEvent)
        }
    }
}

