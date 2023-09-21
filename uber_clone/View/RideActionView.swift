//
//  RideActionView.swift
//  uber_clone
//
//  Created by Muslim on 14/09/23.
//

import UIKit
import MapKit

protocol RideActionViewDelegate {
    func uploadTrip(_ view: RideActionView)
}

enum RideActionViewConfiguration {
    case requestRide
    case tripAccepted
    case pickupPassenger
    case tripInProgress
    case endTrip
    
    init() {
        self = .requestRide
    }
}

enum ButtonAction {
    
    case requestRide
    case cancel
    case getDirection
    case pickUp
    case dropOff
    
    var description: String {
        switch self {
        case .requestRide:
            return "CONRIRM UBERX"
        case .cancel:
            return "CANCEL RIDE"
        case .getDirection:
            return "GET DIRECTION"
        case .pickUp:
            return "PICK UP PASSENGER"
        case .dropOff:
            return "DROP OFF PASSENGER"
        }
    }
    
    init() {
        self = .requestRide
    }
    
}

class RideActionView: UIView {

    //MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Place Title"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Place Address"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.text = "X"
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        
        view.addSubview(label)
        label.centerX(inView: view)
        label.centerY(inView: view)
        
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Uber X"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Confirm Uber X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.layer.cornerRadius = 8
//        button.clipsToBounds = true
        
        return button
    }()
    
    //MARK: - Properties
    
    var config = RideActionViewConfiguration()
    var buttonAction = ButtonAction()
    var delegate: RideActionViewDelegate?
    
    var destination: MKPlacemark? {
        didSet {
            titleLabel.text = destination?.name
            addressLabel.text = destination?.address
        }
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.alignment = .center
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self,
                      top: self.topAnchor,
                      topPadding: 12)
        
        addSubview(infoView)
        infoView.centerX(inView: self,
                         top: stack.bottomAnchor,
                         topPadding: 12)
        infoView.setDimensions(width: 60,
                               height: 60)
        infoView.layer.cornerRadius = 30
        infoView.clipsToBounds = true
        
        addSubview(infoLabel)
        infoLabel.centerX(inView: self,
                         top: infoView.bottomAnchor,
                         topPadding: 8)
        infoLabel.anchor(height: 30)
        
        addSubview(separatorView)
        separatorView.centerX(inView: self,
                              top: infoLabel.bottomAnchor,
                              topPadding: 12)
        separatorView.anchor(left: leftAnchor,
                             right: rightAnchor,
                             leftPadding: 12,
                             rightPadding: 12,
                             height: 0.75)

        addSubview(confirmButton)
        confirmButton.addTarget(self,
                                action: #selector(confirmPressed),
                                for: .touchUpInside)
        confirmButton.anchor(top: separatorView.bottomAnchor,
                             left: leftAnchor,
                             bottom: safeAreaLayoutGuide.bottomAnchor,
                             right: rightAnchor,
                             topPadding: 12,
                             leftPadding: 30, 
                             bottomPadding: 12,
                             rightPadding: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func confirmPressed() {
        delegate?.uploadTrip(self)
    }
    
    //MARK: - Helper Functions
    
    func configureView(withConfig config: RideActionViewConfiguration) {
        
        switch config {
        case .requestRide:
            break
        case .tripAccepted:
            titleLabel.text = "En route to Passenger"
            buttonAction = .getDirection
            confirmButton.setTitle(buttonAction.description, for: .normal)
        case .pickupPassenger:
            break
        case .tripInProgress:
            break
        case .endTrip:
            break
        }
    }
}
