//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import UIKit
protocol PokemonDetailDelegate: NSObjectProtocol {
    func filterBy(type: String)
}

final class PokemonDetailViewController: UIViewController {
    private let viewModel = PokemonDetailViewModel()
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    private let shinyImageView = UIImageView()
    private let typesStack = UIStackView()
    private let statsStack = UIStackView()
    
    var pokemonId: Int!
    weak var delegate: PokemonDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detalle"
        view.backgroundColor = .systemBackground
        setupLayout()
        
        viewModel.didUpdate = { [weak self] in
            self?.updateUI()
        }
        viewModel.fetchPokemonDetail(id: pokemonId)
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        typesStack.axis = .horizontal
        typesStack.spacing = 8
        statsStack.axis = .vertical
        statsStack.spacing = 4
        
        [nameLabel, imageView, shinyImageView, typesStack, statsStack].forEach { stack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        imageView.contentMode = .scaleAspectFit
        shinyImageView.contentMode = .scaleAspectFit
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
    }
    
    private func updateUI() {
        guard let model = viewModel.pokemon else { return }
        
        nameLabel.text = "#\(model.id) \(model.name.capitalized)"
        
        if let url = URL(string: model.sprites.front_default ?? "") {
            loadImage(from: url, into: imageView)
        }
        if let shinyURL = URL(string: model.sprites.front_shiny ?? "") {
            loadImage(from: shinyURL, into: shinyImageView)
        }
        
        typesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for t in model.types {
            let btn = UIButton(type: .system)
            btn.setTitle(t.type.name.capitalized, for: .normal)
            btn.backgroundColor = TypeColors.color(for: t.type.name)
            btn.tintColor = .white
            btn.layer.cornerRadius = 12
            btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            btn.addAction(UIAction { [weak self] _ in
                self?.showPokemons(ofType: t.type.name)
            }, for: .touchUpInside)
            typesStack.addArrangedSubview(btn)
        }
        
        statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for stat in model.stats {
            let label = UILabel()
            label.text = "\(stat.stat.name.capitalized): \(stat.base_stat)"
            statsStack.addArrangedSubview(label)
        }
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
    
    private func showPokemons(ofType type: String) {
        delegate?.filterBy(type: type)
        self.dismiss(animated: true)
    }
}
