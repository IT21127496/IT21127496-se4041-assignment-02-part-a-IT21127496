import Firebase
import SwiftUI

struct EventService {

    // MARK: - Fetch Events
    static func fetchEvents(completion: @escaping ([Event]) -> Void) {
        let db = Firestore.firestore()
        db.collection("events").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No events found.")
                return
            }
            let events = documents.map { (queryDocumentSnapshot) -> Event in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let date = data["date"] as? Timestamp ?? Timestamp()
                let location = data["location"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
                let userId = data["userId"] as? String ?? ""
                let participants = data["participants"] as? [String] ?? []
                let availableSlots = data["availableSlots"] as? Int ?? 0
                let duration = data["duration"] as? Int ?? 0
                let city = data["city"] as? String ?? ""

                return Event(
                    id: id, title: title, description: description, date: date, location: location,
                    userId: userId, participants: participants, duration: duration, city: city,
                    availableSlots: availableSlots)
            }
            completion(events)
        }
    }

    // MARK: - Create Event
    static func createEvent(event: Event, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("events").addDocument(data: [
            "title": event.title,
            "description": event.description,
            "userId": event.userId,
            "participants": event.participants,
            "date": event.date,
            "duration": event.duration,
            "availableSlots": event.availableSlots,
            "city": event.city,
            "location": event.location
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            completion(error)
        }
    }

    // MARK: - Update Event
    static func updateEvent(event: Event, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("events").document(event.id!).updateData([
            "title": event.title,
            "description": event.description,
            "date": event.date, // Ensure `date` is a Firestore `Timestamp`
            "location": event.location, // Ensure `location` is a Firestore `GeoPoint`
            "city": event.city,
            "duration": event.duration,
            "availableSlots": event.availableSlots
        ]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated")
            }
            completion(error)
        }
    }


    // MARK: - Delete Event
    static func deleteEvent(event: Event, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("events").document(event.id!).delete { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully removed")
            }
            completion(error)
        }
    }

    // MARK: - Join Event
    static func joinEvent(event: Event, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("events").document(event.id!).updateData([
            "participants": FieldValue.arrayUnion([Auth.auth().currentUser!.uid])
        ]) { error in
            if let error = error {
                print("Error joining event: \(error.localizedDescription)")
            } else {
                print("Successfully joined event")
            }
            completion(error)
        }
    }
}
