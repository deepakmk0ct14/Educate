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
    func signUpWithEmail(userDetails: UserDetails, withPassword password: String, onCompletion completion: @escaping ((_ status: Bool, _ error: String?) -> Void))
    func signInWithEmail(email: String, withPassword password: String, onCompletion completion: @escaping ((_ status: Bool, _ error: String?) -> Void))
    func isLoggedIn() -> Bool
    func getUserDetails(email: String, onCompletion: @escaping ((UserDetails)->Void))
    func signOut(onCompletion: @escaping ((_ success: Bool )->Void))
    func getSchoolsList(onCompletion: @escaping (([School])->Void))
    func getEventsList(onCompletion: @escaping (([Event])->Void))
    func createEvent(event: Event, onCompletion completion: @escaping ((_ isSuccess: Bool)->Void))
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
    
    func signUpWithEmail(userDetails: UserDetails, withPassword password: String, onCompletion completion: @escaping ((_ status: Bool, _ error: String?) -> Void)) {
        Auth.auth().createUser(withEmail: userDetails.email, password: password) { (result, error) in
            self.addUserWithSchoolDetails(user: userDetails) { isSuccess in
                completion(isSuccess, error?.localizedDescription)
            }
        }
    }
    
    func addUserWithSchoolDetails(user: UserDetails, onCompletion completion: @escaping ((Bool) -> Void)) {
        let db = Firestore.firestore()
        _ = db.collection("User").addDocument(data: ["Name":user.name ,
                                                     "Email":user.email ,
                                                     "SchoolId":user.school?.id ?? "",
                                                     "SchoolName":user.school?.name ?? "",
                                                     "isTeacher": user.isTeacher],
                                              completion: { (error) in
                                                completion(error == nil)
        })
    }

    func getUserDetails(email: String, onCompletion: @escaping ((UserDetails)->Void)) {
        let db = Firestore.firestore()
        _ = db.collection("User").whereField("Email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            guard  err == nil, let documents = querySnapshot?.documents else  { return }
            let users = documents.filter { (document) -> Bool in
                let emailId = document["Email"] as? String
                return emailId == email
            }.map { (docData) -> UserDetails in
                let name = docData["Name"] as? String
                let email = docData["Email"] as? String
                let schoolId = docData["SchoolId"] as? String
                let schoolName = docData["SchoolName"] as? String
                let isTeacher = docData["isTeacher"] as? Int == 1
                let school = School(id: schoolId, name: schoolName, address: "")
                return UserDetails(name: name ?? "", email: email ?? "", school: school, isTeacher: isTeacher)
            }
            if let user = users.first {
                onCompletion(user)
            }
        }
    }
    
    func getSchoolsList(onCompletion: @escaping (([School])->Void)) {
        let db = Firestore.firestore()
        _ = db.collection("Schools").getDocuments(source: .default) { (querySnapshot, err) in
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
        _ = db.collection("Events").getDocuments(source: .default) { (querySnapshot, err) in
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
    
    func createEvent(event: Event, onCompletion completion: @escaping ((_ isSuccess: Bool) -> Void)) {
        let db = Firestore.firestore()
        _ = db.collection("Events").addDocument(data: ["Date":event.date ?? "",
                                                       "Description":event.description ?? "",
                                                       "Name":event.name ?? "",
                                                       "SchoolId":event.schoolId ?? "",
                                                       "SchoolName":event.schoolName ?? ""],
                                                completion: { (error) in
                                                    completion(error == nil)
        })
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy" //yyyy
        return formatter.string(from: date as Date)
    }
}
