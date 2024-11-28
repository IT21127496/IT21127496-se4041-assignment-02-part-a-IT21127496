

import Firebase
import FirebaseFirestore

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let profileImageUrl: String?
    let email: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == id
    }
}
