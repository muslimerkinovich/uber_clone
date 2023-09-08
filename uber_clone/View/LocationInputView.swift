//
//  LocationInputView.swift
//  uber_clone
//
//  Created by Muslim on 08/09/23.
//

import UIKit

protocol LocationInputViewDelegate {
    func dissmisLocationInputView()
}

class LocationInputView: UIView {
    
    //MARK: - UI Properties
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    // title
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Tashkent, Uzbekistan"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    // from text field
    
    private let startingLocationTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .systemGray6
        tf.placeholder = "Current location"
        tf.layer.cornerRadius = 8
        tf.clipsToBounds = true
        
        let paddingView = UIView()
        paddingView.setDimensions(widht: 8, height: 8)
        
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    // to text field
    
    private let endingLocationTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .systemGray4
        tf.placeholder = "Enter a destination address..."
        tf.layer.cornerRadius = 8
        tf.clipsToBounds = true
        
        let paddingView = UIView()
        paddingView.setDimensions(widht: 8, height: 8)
        
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    // from indicator view
    
    private let startingIndicatorView: UIView = {
        let view = UIView()
        view.setDimensions(widht: 6, height: 6)
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    // to indicator view
    
    private let endingIndicatorView: UIView = {
        let view = UIView()
        view.setDimensions(widht: 6, height: 6)
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        
        view.backgroundColor = .darkGray
        
        return view
    }()
    
    // indicators linking view
    
    private let linkingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 1
        view.clipsToBounds = true
        view.backgroundColor = .systemGray3
        
        return view
    }()
    //MARK: - Properties
    
    var delegate: LocationInputViewDelegate?
    var user: User? {
        didSet {
            titleLbl.text = user?.email
        }
    }
    //MARK: - LifeCycle methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        addSubview(backButton)
        backButton.addTarget(self,
                         action: #selector(handleBackButton),
                         for: .touchUpInside)
        backButton.anchor(top: self.topAnchor,
                          left: self.leftAnchor,
                          topPadding: 54,
                          leftPadding: 12,
                          width: 24,
                          height: 24)
        
        addSubview(titleLbl)
        titleLbl.centerY(inView: backButton)
        titleLbl.centerX(inView: self)
        
        addSubview(startingLocationTextField)
        startingLocationTextField.anchor(top: titleLbl.bottomAnchor,
                                         left: backButton.rightAnchor,
                                         right: self.rightAnchor,
                                         topPadding: 16,
                                         leftPadding: 8,
                                         rightPadding: 36,
                                         height: 36)
        
        addSubview(endingLocationTextField)
        endingLocationTextField.anchor(top: startingLocationTextField.bottomAnchor,
                                       left: startingLocationTextField.leftAnchor,
                                       right: startingLocationTextField.rightAnchor,
                                       topPadding: 12,
                                       height: 36)
        
        addSubview(startingIndicatorView)
        startingIndicatorView.centerY(inView: startingLocationTextField)
        startingIndicatorView.centerX(inView: backButton)
        
        addSubview(endingIndicatorView)
        endingIndicatorView.centerY(inView: endingLocationTextField)
        endingIndicatorView.centerX(inView: backButton)
        
        addSubview(linkingView)
        linkingView.centerX(inView: backButton)
        linkingView.anchor(top: startingIndicatorView.bottomAnchor,
                           bottom: endingIndicatorView.topAnchor,
                           topPadding: 4,
                           bottomPadding: 4,
                           width: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    @objc func handleBackButton() {
        print("Handle back")
        
        delegate?.dissmisLocationInputView()
    }
    
}
