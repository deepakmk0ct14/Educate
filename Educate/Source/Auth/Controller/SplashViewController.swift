//
//  SplashViewController.swift
//  Educate
//
//   3/25/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, AuthRouter, Storyboarding {
    let mViewModel = AuthViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentInitialScreenOnLogin(isLoggedIn: mViewModel.isLoggedIn())
    }
}
