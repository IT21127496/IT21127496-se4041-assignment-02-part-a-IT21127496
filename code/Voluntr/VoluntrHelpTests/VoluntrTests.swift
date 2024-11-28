

import XCTest
import Firebase

@testable import Voluntr

final class BetterHelpTests: XCTestCase {

    func testEventService() throws {
        let event = Event(id: "1", title: "Test Event", description: "This is a test event", date: Timestamp(date: Date()), location: GeoPoint(latitude: 0, longitude: 0), userId: "1", participants: [], duration: 60, city: "Test City", availableSlots: 10)

        // Create Event
        EventService.createEvent(event: event) { (error) in
            XCTAssertNil(error, "Error creating event")
        }

        // Fetch Events
        EventService.fetchEvents { (events) in
            XCTAssertNotNil(events, "Events not fetched")
        }
        
        // Delete Event
        EventService.deleteEvent(event: event) { (error) in
            XCTAssertNil(error, "Error deleting event")
        }
        
    }

}
