//
//  AuthRouter.swift
//  Educate
//
//   3/25/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit
protocol AuthRouter {
    func onLoginSuccess()
    func presentInitialScreenOnLogin(isLoggedIn:Bool)
}

extension AuthRouter where Self: UIViewController {
    func presentInitialScreenOnLogin(isLoggedIn:Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboard = storyboard.instantiateViewController(withIdentifier: isLoggedIn == true ? "DashboardViewController" : "LoginViewController")
        dashboard.modalPresentationStyle = .fullScreen
        present(dashboard, animated: true, completion: nil)
    }

    func onLoginSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController")
        dashboardViewController.modalPresentationStyle = .fullScreen
        present(dashboardViewController, animated: true, completion: nil)
    }

    func onLogout() {
        guard let loginViewController = LoginViewController.fromStoryboard() else { return   }
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }

    func onSignUpScreenButton() {
         guard let signUpViewController = SignUpViewController.fromStoryboard() else { return   }
        signUpViewController.modalPresentationStyle = .fullScreen
        present(signUpViewController, animated: true, completion: nil)
    }

    func onSchoolsScreen(onSelectedSchool: @escaping ((School)->Void)) {
        guard let schoolsViewController = SchoolsViewController.fromStoryboard() else { return   }
        schoolsViewController.onSelectedSchool = onSelectedSchool
        present(schoolsViewController, animated: true, completion: nil)
    }
}
