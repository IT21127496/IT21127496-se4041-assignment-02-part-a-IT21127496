

import SwiftUI

struct JoinedEventsView: View {
    @StateObject var eventViewModel = EventListViewModel()
    @EnvironmentObject var authService: AuthService
    
    var filteredEvents: [Event] {
        return eventViewModel.events.filter { $0.participants.contains(authService.currentUser?.id ?? "") }
    }
    
    
    // TODO: filter out users events
    var body: some View {
        List(filteredEvents) { event in
            NavigationLink {
                EventDetailsView(event: event)
            } label: {
                EventRow(event: event)
            }
        }.navigationTitle("Joined Events")
    }
}

#Preview {
    JoinedEventsView().environmentObject(AuthService())
}
