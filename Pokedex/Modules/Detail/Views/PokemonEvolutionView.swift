//
//  PokemonEvolutionView.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import UIKit

final class PokemonEvolutionView: UIView {
    
    private let stack = UIStackView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        titleLabel.text = "Evoluciones"
        addSubview(titleLabel)
        addSubview(stack)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with speciesList: [Int]) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for id in speciesList {
            let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            if let url = URL(string: imageURL) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }
            }
            
            imageView.tag = id
            stack.addArrangedSubview(imageView)
        }
    }
}
