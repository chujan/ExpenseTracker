//
//  User.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 21/05/2024.
//
import FirebaseAuth
struct User {
    var uid: String
    var firstName: String
    var lastName: String
    var email: String
    
    init(uid: String = "", firstName: String, lastName: String, email: String = "") {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    func toDictionary() -> [String: Any] {
            return [
                "uid": uid,
                "firstName": firstName,
                "lastName": lastName,
                "email": email
            ]
        }
        static func fetchUserDetails(uid: String, completion: @escaping (User?) -> Void) {
                // Example: Use Firebase Firestore to fetch user details
                // Replace this with your actual code to fetch user details from Firebase
                // ...

                // For now, let's assume a simple case where the user details are hardcoded
                // Replace this with your actual logic to fetch user details from Firebase
                let user = User(uid: uid, firstName: "John", lastName: "Doe")

                completion(user)
            }
}


