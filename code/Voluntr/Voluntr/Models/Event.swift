
import Firebase
import FirebaseFirestore
import SwiftUI

struct Event: Identifiable, Decodable, Equatable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var date: Timestamp
    var location: GeoPoint
    var userId: String
    var participants: [String] // Array to store the user IDs of participants
    var duration: Int
    var city: String
    var availableSlots: Int
    
    // Additional properties for managing event participation
    var isUserParticipant: Bool { // Computed property to check if the current user is a participant
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return false
        }
        return participants.contains(currentUserID)
    }
    
    // Additional methods for managing event participation
    mutating func addParticipant(userID: String) {
        participants.append(userID)
    }
    
    mutating func removeParticipant(userID: String) {
        participants.removeAll { $0 == userID }
    }
}
