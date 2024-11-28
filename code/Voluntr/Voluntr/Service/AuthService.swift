

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import CryptoKit
import AuthenticationServices

class AuthService: NSObject, ObservableObject, ASAuthorizationControllerDelegate  {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var currentUser: User?
    private var tempUserSession: FirebaseAuth.User?
    
    private let service = UserService()
    override init() {
        super.init()
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.userSession = Auth.auth().currentUser
                self.fetchUserFromDB()
            } else{
                self.userSession = nil
            }
        }
    }
    //MARK: - Login
    func credentialLogin(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUserFromDB()
            print("DEBUG: Did Log user in.. \(String(describing: self.userSession?.email))")
        }
    }
    
    //MARK: - Register
    func register(withEmail email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription), code: \(error._code)")
                return
            }
            
            guard let user = result?.user else { return }
            self.tempUserSession = user
            let userData = ["email": email,
                            "username": username.lowercased(),
                            "uid": user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(userData) { error in
                    if let error = error {
                        print("DEBUG: Failed to upload user data to Firestore with error: \(error.localizedDescription)")
                    } else {
                        print("DEBUG: Did upload user data successfully.")
                        self.didAuthenticateUser = true
                    }
                }
        }
    }

    
    //MARK: - Logout
    func logout() {
        didAuthenticateUser = false
        userSession = nil
        try? Auth.auth().signOut()
    }
    
    //    func uploadProfileImage(_ image: UIImage) {
    //        guard let uid = tempUserSession?.uid else { return }
    //
    //        ImageUploader.uploadImage(image: image) { profileImageUrl in
    //            Firestore.firestore().collection("users")
    //                .document(uid)
    //                .updateData(["profileImageUrl": profileImageUrl]) { _ in
    //                    self.userSession = self.tempUserSession
    //                    self.fetchUser()
    //                }
    //        }
    //    }
    
    func fetchUserFromDB() {
        guard let uid = self.userSession?.uid else { return }
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
}
