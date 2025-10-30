//
//  PokemonTypesView.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import UIKit

final class PokemonTypesView: UIView {
    
    private let stackView = UIStackView()
    var onTypeSelected: ((String) -> Void)? 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with types: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for type in types {
            let btn = UIButton(type: .system)
            btn.setTitle(type.capitalized, for: .normal)
            btn.backgroundColor = TypeColors.color(for: type)
            btn.tintColor = .white
            btn.layer.cornerRadius = 12
            btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            btn.alpha = 0
            btn.transform = CGAffineTransform(translationX: 0, y: 10)
            
            btn.addAction(UIAction { [weak self] _ in
                self?.onTypeSelected?(type)
            }, for: .touchUpInside)
            
            stackView.addArrangedSubview(btn)
        }
        
        animateButtons()
    }
    
    private func animateButtons() {
        let buttons = stackView.arrangedSubviews
        for (index, button) in buttons.enumerated() {
            UIView.animate(withDuration: 1.5,
                           delay: 0.05 * Double(index),
                           options: [.curveEaseOut],
                           animations: {
                button.alpha = 1
                button.transform = .identity
            })
        }
    }
}
