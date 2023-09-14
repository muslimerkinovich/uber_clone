//
//  LocationInputActivationView.swift
//  uber_clone
//
//  Created by Muslim on 08/09/23.
//

import UIKit

protocol LocationInputActivationViewDelegate {
    func presentLocationInputView()
}

class LocationInputActivationView: UIView {
    
    //MARK: - UI Properties
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Where to Go?"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    //MARK: - Properties

    var delegate: LocationInputActivationViewDelegate?
    
    //MARK: - LifeCycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        layer.cornerRadius = 8
//        clipsToBounds = true
        
        addSubview(indicatorView)
        indicatorView.centerY(inView: self,
                              left: self.leftAnchor,
                              leftPadding: 16)
        indicatorView.setDimensions(width: 6,
                                    height: 6)
        
        addSubview(titleLbl)
        titleLbl.centerY(inView: self)
        titleLbl.anchor(left: indicatorView.rightAnchor,
                        right: self.rightAnchor,
                        leftPadding: 8,
                        rightPadding: 8)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(viewDidTap))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(tap)
    }
    
    @objc func viewDidTap() {
        
        delegate?.presentLocationInputView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

