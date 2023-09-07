//
//  SignUpVC.swift
//  uber_clone
//
//  Created by Muslim on 07/09/23.
//

import UIKit

class SignUpVC: UIViewController {

    //MARK: - Properties
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = .init(name: "Avenir-Light", size: 36)
        label.textColor = .customWhite
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: UIImage(named: "mail"),
                                           textField: emailTextField)
        view.anchor(height: 50)
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: UIImage(named: "person"),
                                           textField: fullNameTextField)
        view.anchor(height: 50)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: UIImage(named: "lock"),
                                           textField: passwordTextField)
        view.anchor(height: 50)
        return view
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: UIImage(named: "account"),
                                               segmentedControl: accountSegmentedControl)
        view.anchor(height: 80)
        return view
    }()
    
    private let emailTextField: UITextField = .init(withPlaceholder: "Email", isSecuryEntry: false)
    
    private let fullNameTextField: UITextField = {
        UITextField().textfield(withPlaceholder: "Full Name", isSecuryEntry: true)
    }()
    
    private let passwordTextField: UITextField = {
        UITextField().textfield(withPlaceholder: "Password", isSecuryEntry: true)
    }()
    
    private let accountSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = .customWhite
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.customWhite], for: .normal)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.backgroundColor], for: .selected)
        return sc
    }()
    
    private let signUpButton: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)

        return button
    }()
    
    private let loginButton: UIButton = { [`self` = ViewController.self] in
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ])
        attributedTitle.append(NSAttributedString(
            string: "Log In",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    //MARK: - Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavBar()
    }
    
    //MARK: - Selectors

    @objc func handleLogInButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUpButton() {
        
    }
    
    //MARK: - SetupFunctions
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
         
        view.addSubview(titleLbl)
        titleLbl.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLbl.centerX(inView: view)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView,
                                                       fullNameContainerView,
                                                       passwordContainerView,
                                                       accountTypeContainerView,
                                                       signUpButton,])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.anchor(top: titleLbl.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         topPadding: 40,
                         leftPadding: 16,
                         rightPadding: 16)
        
        view.addSubview(loginButton)
        loginButton.centerX(inView: view)
        loginButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   height: 32)
        
        signUpButton.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLogInButton), for: .touchUpInside)
        
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
}
