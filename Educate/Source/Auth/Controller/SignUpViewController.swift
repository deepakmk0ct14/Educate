//
//  SignUpViewController.swift
//  Educate
//
//  Created by Deepak on 3/25/20.
//  Copyright © 2020 Deepak. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController, AuthRouter, Storyboarding {

    @IBOutlet weak var mFullName: UITextField!
    @IBOutlet weak var mUsername: UITextField!
    @IBOutlet weak var mPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mErrorLabel: UILabel!
    let mViewModel = AuthViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpToolBarForKeyboard()
    }
    
    func setUpToolBarForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        mFullName.enableDoneButton(toolBarDelegate: self)
        mUsername.enableDoneButton(toolBarDelegate: self)
        mPassword.enableDoneButton(toolBarDelegate: self)
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
        mErrorLabel.isHidden = true
        guard let userName = mUsername.text, let password = mPassword.text else {
            return
        }
        mViewModel.signUp(email: userName, passowrd: password, success: {
            self.onLoginSuccess()
        }) { (error) in
            self.mErrorLabel.text = error
            self.mErrorLabel.isHidden = false
        }
    }
    
    @IBAction func onSigIn(_ sender: Any) {
        onLogout()
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}
extension SignUpViewController: KeyboardToolbarDelegate {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOf textField: UITextField) {
        self.view.endEditing(true)
    }
}
