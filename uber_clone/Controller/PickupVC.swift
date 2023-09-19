//
//  PickupVC.swift
//  uber_clone
//
//  Created by Muslim on 19/09/23.
//

import UIKit
import MapKit

protocol PickupDelegate {
    
    func didAcceptTrip(_ trip: Trip)
}

class PickupVC: UIViewController {

    //MARK: - UI Properties
    private let mapView = MKMapView()
    
    private let pickupLabel: UILabel = {
        let label = UILabel()
        label.text = "Would you like pick up this passenger?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("Accept trip", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    //MARK: - Properties
    
    var trip: Trip
    var delegate: PickupDelegate?
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        print(trip.passengerUID)
    }
    
    //MARK: - Selectors
    
    @objc func cancelPressed() {
        dismiss(animated: true)
    }
    
    @objc func acceptPressed() {
        delegate?.didAcceptTrip(trip)
    }
    
    //MARK: - Setup Functions
    
    
    func setupUI() {
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.leftAnchor,
                            topPadding: 0,
                            leftPadding: 16,
                            width: 32,
                            height: 32)
        
        view.addSubview(mapView)
        mapView.centerX(inView: view)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       topPadding: 80,
                       width: 270,
                       height: 270)
        mapView.layer.cornerRadius = 270 / 2
        mapView.clipsToBounds = true
        setupMapView()
        
        view.addSubview(pickupLabel)
        pickupLabel.centerX(inView: mapView, top: mapView.bottomAnchor, topPadding: 16)
        pickupLabel.anchor(width: view.frame.width - 32)
        
        view.addSubview(acceptButton)
        acceptButton.anchor(top: pickupLabel.bottomAnchor,
                            left: pickupLabel.leftAnchor,
                            right: pickupLabel.rightAnchor,
                            topPadding: 16,
                            height: 52)
        acceptButton.addTarget(self, action: #selector(acceptPressed), for: .touchUpInside)
        
    }
    
    func setupMapView() {
        let region = MKCoordinateRegion(center: trip.pickupCoordinates,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let pickupAnnotation = MKPointAnnotation()
        pickupAnnotation.coordinate = trip.pickupCoordinates
        mapView.addAnnotation(pickupAnnotation)
        mapView.selectAnnotation(pickupAnnotation, animated: true)
    }
    
    //MARK: - Helpers

}
