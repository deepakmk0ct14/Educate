//
//  LoginViewController.swift
//  Educate
//
//   3/25/20.
//  Copyright © 2020  All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AuthRouter, Storyboarding {
    
    let mViewModel = AuthViewModel()
    @IBOutlet weak var mUserName: UITextField!
    @IBOutlet weak var mPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpToolBarForKeyboard()
    }
    
    func setUpToolBarForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        mUserName.enableDoneButton(toolBarDelegate: self)
        mPassword.enableDoneButton(toolBarDelegate: self)
    }
    
    @IBAction func onForgotButton(_ sender: Any) {
        
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        mErrorLabel.isHidden = true
        guard let userName = mUserName.text, let password = mPassword.text else {
            return
        }
        mViewModel.signIn(email: userName, passowrd: password, success: {
            self.onLoginSuccess()
        }) { (error) in
            self.mErrorLabel.text = error
            self.mErrorLabel.isHidden = false
        }
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
    
    @IBAction func onSignUp(_ sender: Any) {
        onSignUpScreenButton()
    }
    
}

extension LoginViewController: KeyboardToolbarDelegate {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOf textField: UITextField) {
        self.view.endEditing(true)
    }
}
