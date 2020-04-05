//
//  AuthViewModel.swift
//  Educate
//
//   3/25/20.
//  Copyright © 2020  All rights reserved.
//

import Foundation

class AuthViewModel  {
    private var service: ServicesType
    
    init(service : ServicesType = Services()) {
        self.service = service
    }
    func signUp(userDetails: UserDetails, passowrd: String, success: @escaping (()-> Void), error: @escaping ((_ error: String?)-> Void)) {
        service.signUpWithEmail(userDetails: userDetails, withPassword: passowrd) { (status, errorDetails) in
            if(status) {
                self.service.getUserDetails(email: userDetails.email) { (user) in
                    SharedDatasource.datasource.userDetails = user
                    success()
                }
            }else{
                error(errorDetails)
            }
        }
    }
    
    func signIn(email: String, passowrd: String, success: @escaping (()-> Void), error: @escaping ((_ error: String?)-> Void)){
        service.signInWithEmail(email: email, withPassword: passowrd) { (status, errorDetails) in
            if(status) {
                self.service.getUserDetails(email: email) { (user) in
                    SharedDatasource.datasource.userDetails = user
                    success()
                }
            }else{
                error(errorDetails)
            }
        }
    }
    
    func isLoggedIn()->Bool {
        return service.isLoggedIn()
    }
    
    func getSchoolsList(onCompletion:@escaping(([School])->Void)) {
        service.getSchoolsList(onCompletion: onCompletion)
    }
    
    func onLogOut(onCompletion:@escaping((_ Success: Bool)->Void)){
        service.signOut(onCompletion: onCompletion)
    }
}
