//
//  LocationCell.swift
//  uber_clone
//
//  Created by Muslim on 08/09/23.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {
    
    //MARK: - UIProperties
    
    var placemark: MKPlacemark? {
        didSet {
            titleLabel.text = placemark?.name
            descriptionLabel.text = placemark?.address
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Location Address"
        label.textColor = .backgroundColor
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Location Description"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    //MARK: - Properties
    
    static let identifier = String(describing: LocationCell.self)
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        addSubview(titleLabel)
//        titleLabel.anchor(top: self.topAnchor,
//                          left: self.leftAnchor,
//                          right: self.rightAnchor,
//                          topPadding: 8,
//                          leftPadding: 16,
//                          rightPadding: 16)
//        
//        addSubview(descriptionLabel)
//        descriptionLabel.anchor(top: titleLabel.topAnchor,
//                               left: titleLabel.leftAnchor,
//                               right: titleLabel.rightAnchor)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        addSubview(stackView)
        stackView.centerY(inView: self,
                          left: self.leftAnchor,
                          leftPadding: 12)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
