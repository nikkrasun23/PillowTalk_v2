//
//  CategoryOverlayItemView.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 23/06/2025.
//

import UIKit

struct CategoryOverlayItemModel {
    let categoryId: Int
    let text: String
    let analyticsParam: String
}

final class CategoryOverlayItemView: UIView {
    private var model: CategoryOverlayItemModel?
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Commissioner-Regular", size: 16)
        label.textColor = UIColor(hex: "#33363F")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectionHandler: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func configure(with model: CategoryOverlayItemModel) {
        self.model = model
        
        textLabel.text = model.text
    }

    private func setup() {
        layer.cornerRadius = 8
        backgroundColor = UIColor(hex: "#F4F4F4")
        
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        guard let model else { return }
        
        selectionHandler?(model.categoryId)
    }
}
