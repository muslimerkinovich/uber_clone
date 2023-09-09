//
//  Extensions.swift
//  uber_clone
//
//  Created by Muslim on 06/09/23.
//

import Foundation
import UIKit
import MapKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let customWhite = UIColor(white: 1, alpha: 0.85)
    static let backgroundColor = rgb(red: 25, green: 25, blue: 25)
    static let mainBlueTint = rgb(red: 17, green: 154, blue: 237)
}

extension UIView {
    // for textfields
    convenience init(withImage image: UIImage?, textField: UITextField) {
        
        self.init()
        
        let imageView = UIImageView()
        imageView.alpha = 0.85
        imageView.image = image
        addSubview(imageView)
        imageView.anchor(left: leftAnchor, leftPadding: 8, width: 24, height: 24)
        imageView.centerY(inView: self)
        
        addSubview(textField)
        textField.anchor(left: imageView.rightAnchor,
                               right: rightAnchor,
                               leftPadding: 8)
        textField.centerY(inView: self)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(left: imageView.leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             height: 1)
    }
    
    func inputContainerView(withImage image: UIImage?,
                            textField: UITextField? = nil,
                            segmentedControl: UISegmentedControl? = nil) -> UIView {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.alpha = 0.85
        imageView.image = image
        view.addSubview(imageView)
        
        if let textField {
            imageView.anchor(left: view.leftAnchor,
                             leftPadding: 8,
                             width: 24,
                             height: 24)
            imageView.centerY(inView: view)
            
            view.addSubview(textField)
            textField.anchor(left: imageView.rightAnchor,
                                   right: view.rightAnchor,
                                   leftPadding: 8)
            textField.centerY(inView: view)
        }
        
        if let segmentedControl {
            imageView.anchor(top: view.topAnchor,
                             left: view.leftAnchor,
                             topPadding: 8,
                             leftPadding: 8,
                             width: 24,
                             height: 24)
            
            view.addSubview(segmentedControl)
            segmentedControl.anchor(top: imageView.bottomAnchor,
                                    left: view.leftAnchor,
                                    bottom: view.bottomAnchor,
                                    right: view.rightAnchor,
                                    topPadding: 8,
                                    leftPadding: 8,
                                    bottomPadding: 8,
                                    rightPadding: 8)
        }
        
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(left: imageView.leftAnchor,
                             bottom: view.bottomAnchor,
                             right: view.rightAnchor,
                             height: 1)
        return view
    }
    
    // for all
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                topPadding: CGFloat = 0,
                leftPadding: CGFloat = 0,
                bottomPadding: CGFloat = 0,
                rightPadding: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top {
            topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        
        if let left {
            leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        
        if let bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        
        if let right {
            rightAnchor.constraint(equalTo: right, constant: -rightPadding).isActive = true
        }
        
        if let width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView,
                 constant: CGFloat = 0,
                 top: NSLayoutYAxisAnchor? = nil,
                 topPadding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor,
                                 constant: constant).isActive = true
        
        if let top {
            topAnchor.constraint(equalTo: top,
                                 constant: topPadding).isActive = true
        }
        
    }
    
    func centerY(inView view: UIView,
                 constant: CGFloat = 0,
                 left: NSLayoutXAxisAnchor? = nil,
                 leftPadding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                 constant: constant).isActive = true
        
        if let left {
            leftAnchor.constraint(equalTo: left,
                                  constant: leftPadding).isActive = true
        }
    }
    
    func setDimensions(widht: CGFloat,
                       height: CGFloat) {
        widthAnchor.constraint(equalToConstant: widht).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }
}


extension UITextField {
    
    func textfield(withPlaceholder placeholder: String,
                   isSecuryEntry: Bool) -> UITextField {
        
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = .systemFont(ofSize: 16)
        tf.keyboardAppearance = .dark
        tf.textColor = .lightGray
        tf.isSecureTextEntry = isSecuryEntry
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ])
        
        return tf
    }
    
    convenience init(withPlaceholder placeholder: String,
                     isSecuryEntry: Bool) {
        
        self.init()
        self.borderStyle = .none
        self.font = .systemFont(ofSize: 16)
        self.keyboardAppearance = .dark
        self.textColor = .lightGray
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ])
        
    }
}


extension MKPlacemark {
    
    var address: String? {
        get {
            guard let subThoroughfare else { return nil }
            guard let thoroughfare else { return nil }
            guard let locality else { return nil }
            guard let administrativeArea else { return nil }
            
            return "\(subThoroughfare), \(thoroughfare), \(locality), \(administrativeArea)"
        }
    }
}
