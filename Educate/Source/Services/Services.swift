//
//  Services.swift
//  Educate
//
//   3/25/20.
//  Copyright © 2020  All rights reserved.
//

import Foundation
import Firebase
protocol ServicesType {
    func signUpWithEmail(email: String, withPassword password: String, onCompletion completion: @escaping ((_ status: Bool, _ error: String?) -> Void))
    func signInWithEmail(email: String, withPassword password: String, onCompletion completion: @escaping ((_ status: Bool, _ error: String?) -> Void))
    func isLoggedIn() -> Bool
    func signOut(onCompletion: @escaping ((_ success: Bool )->Void))
    func getSchoolsList(onCompletion: @escaping (([School])->Void))
    func getEventsList(onCompletion: @escaping (([Event])->Void))
}

class Services: ServicesType {
    
    func signInWithEmail(email: String, withPassword password: String, onCompletion completion: @escaping ((Bool, String?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            completion(error==nil, error?.localizedDescription)
        }
    }
    func signOut(onCompletion: @escaping ((_ success: Bool )->Void)) {
        do {
            try Auth.auth().signOut()
            onCompletion(true)
        } catch  {
            onCompletion(false)
        }
    }
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    func signUpWithEmail(email: String, withPassword password: String, onCompletion completion: @escaping ((Bool, String?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            completion(error==nil, error?.localizedDescription)
        }
    }
    
    func addUserWithSchoolDetails(user: UserDetails, onCompletion completion: @escaping (() -> Void)) {
        
    }

    func getSchoolsList(onCompletion: @escaping (([School])->Void)) {
        let db = Firestore.firestore()
        _ = db.collection("Schools").getDocuments() { (querySnapshot, err) in
            var schools = [School]()
            guard  err == nil, let documents = querySnapshot?.documents else  {
                return
            }
            schools = documents.map({ (document) -> School in
                let docData =  document.data()
                let name = docData["Name"] as? String
                let address = docData["Address"] as? String
                return School(id: document.documentID, name: name, address: address)
            })
            onCompletion(schools)
        }
    }
    
    func getEventsList(onCompletion: @escaping (([Event])->Void)) {
        let db = Firestore.firestore()
        _ = db.collection("Events").getDocuments() { (querySnapshot, err) in
            var events = [Event]()
            guard  err == nil, let documents = querySnapshot?.documents else  {
                return
            }
            events = documents.map({ (document) -> Event in
                let docData =  document.data()
                let name = docData["Name"] as? String
                let description = docData["Description"] as? String
                let timeInterval = docData["Date"] as? Timestamp
                let schoolId = docData["SchoolId"] as? String
                let schoolName = docData["SchoolName"] as? String
                return Event(id: document.documentID, name: name, description: description, date: self.stringFromDate(timeInterval?.dateValue() ?? Date()), schoolId: schoolId, schoolName: schoolName)
            })
            onCompletion(events)
        }
        
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy" //yyyy
        return formatter.string(from: date as Date)
    }
}
