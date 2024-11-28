

import SwiftUI

struct EventListView: View {
    @StateObject var eventViewModel = EventListViewModel()
    @State private var searchText = ""

    var filteredEvents: [Event] {
        if searchText.isEmpty {
            return eventViewModel.events
        } else {
            return eventViewModel.events.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredEvents) { event in
                NavigationLink(destination: EventDetailsView(event: event)) {
                    EventRowView(event: event)
                }
            }
            .animation(.default, value: filteredEvents)
            .listStyle(.plain)
            .navigationTitle("Search Events")
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    EventListView()
}

struct EventRowView: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            // Display only event details without the image
            Text(event.title)
                .foregroundStyle(.primary)
                .font(.headline)
                .fontWeight(.bold)
            
            HStack {
                Text(event.city)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(dateString(from: event.date.dateValue()))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

func dateString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium  // Adjust date style as needed
    formatter.timeStyle = .none
    return formatter.string(from: date)
}

