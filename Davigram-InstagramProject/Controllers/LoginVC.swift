//
//  LoginVC.swift
//  Davigram-InstagramProject
//
//  Created by David Lin on 3/3/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import Lottie

enum AccountState {
    case existingUser
    case newUser
}

class LoginVC: UIViewController {
    @IBOutlet weak var animationView: Lottie.AnimationView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var accountStateButton: UIButton!
    @IBOutlet weak var accountStateMessageLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var accountState: AccountState = .existingUser
    
    private var authSession = AuthenticationSession()
    
    override func viewWillLayoutSubviews() {
        containerView.layer.cornerRadius = 5.0
        loginButton.layer.cornerRadius = 5.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func startAnimation() {
        animationView.animation = Animation.named("LaunchAnimation", subdirectory: nil)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
                print("missing fields")
                return
        }
        continueLoginFlow(email: email, password: password)
    }
    
    private func continueLoginFlow(email: String, password: String) {
        if accountState == .existingUser {
            authSession.signExistingUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLabel.text = "\(error.localizedDescription)"
                        self?.errorLabel.textColor = .systemRed
                    }
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
        } else {
            authSession.createNewUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLabel.text = "\(error.localizedDescription)"
                        self?.errorLabel.textColor = .systemRed
                    }
                case .success(let newUser):
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
        }
    }
    
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "Main", viewControllerId: "TabBarController")
    }
    
    private func clearErrorLabel() {
        errorLabel.text = ""
    }
    
    @IBAction func toggleAccountState(_ sender: UIButton) {
        // change the account login state
        accountState = accountState == .existingUser ? .newUser : .existingUser
        
        // animation duration
        let duration: TimeInterval = 1.0
        
        if accountState == .existingUser {
            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
                self.loginButton.setTitle("Login", for: .normal)
                self.accountStateMessageLabel.text = "Don't have an account ? Click"
                self.accountStateButton.setTitle("SIGNUP", for: .normal)
            }, completion: nil)
        } else {
            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
                self.loginButton.setTitle("Sign Up", for: .normal)
                self.accountStateMessageLabel.text = "Already have an account ?"
                self.accountStateButton.setTitle("LOGIN", for: .normal)
            }, completion: nil)
        }
    }
    
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            return true
        
    }
}
