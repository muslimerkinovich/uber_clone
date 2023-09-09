//
//  ViewController.swift
//  uber_clone
//
//  Created by Muslim on 06/09/23.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    //MARK: - Properties
     
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = .init(name: "Avenir-Light", size: 36)
        label.textColor = .init(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: UIImage(named: "mail"),
                                           textField: emailTextField)
        view.anchor(height: 50)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: UIImage(named: "lock"),
                                           textField: passwordTextField)
        view.anchor(height: 50)
        return view
    }()
    
    private let emailTextField: UITextField = .init(withPlaceholder: "Email", isSecuryEntry: false)
    
    private let passwordTextField: UITextField = {
        UITextField().textfield(withPlaceholder: "Password", isSecuryEntry: true)
    }()
    
    private let loginButton: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(
            string: "Don't have an account? ",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ])
        attributedTitle.append(NSAttributedString(
            string: "Sign Up",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    
    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - Selectors
    
    @objc func handleLogInButton() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to log in with error: \(error.localizedDescription)")
                return
            }
            
            print("Successfully logged user in...")
//            guard let home = UIApplication.shared.keyWindow?.rootViewController as? HomeVC else { return }
            guard let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first else { return }
            guard let home = keyWindow.rootViewController as? HomeVC else { return }
            
            home.setupVC()
            self.dismiss(animated: true)
        }
    }
    
    @objc func handleSignUpButton() {
        let vc = SignUpVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Setup functions
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
         
        view.addSubview(titleLbl)
        titleLbl.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLbl.centerX(inView: view)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.anchor(top: titleLbl.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         topPadding: 40,
                         leftPadding: 16,
                         rightPadding: 16)
        
        view.addSubview(createAccountButton)
        createAccountButton.centerX(inView: view)
        createAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   height: 32 )
        
        loginButton.addTarget(self, action: #selector(handleLogInButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }


}

