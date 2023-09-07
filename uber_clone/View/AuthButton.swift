//
//  AuthButton.swift
//  uber_clone
//
//  Created by Muslim on 07/09/23.
//

import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.customWhite, for: .normal)
        backgroundColor = .mainBlueTint
        layer.cornerRadius = 8
        anchor(height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
