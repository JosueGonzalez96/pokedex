//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import UIKit

protocol PokemonDetailDelegate: AnyObject {
    func filterBy(type: String)
}

final class PokemonDetailViewController: UIViewController {

    private let viewModel = PokemonDetailViewModel()
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    private let toggleButton = UIButton(type: .system)
    private let typesView = PokemonTypesView()
    private let evolutionView = PokemonEvolutionView()
    private let statsStack = UIStackView()
    
    private var normalSpriteURL: String?
    private var shinySpriteURL: String?
    private var showingShiny = false
    private var statLabels: [UILabel] = []
    
    var pokemonId: Int?
    weak var delegate: PokemonDetailDelegate?
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        bindViewModel()
        fetchData()
    }
    
    private func setupView() {
        title = "Detalle"
        view.backgroundColor = .systemBackground
        
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        
        imageView.contentMode = .scaleAspectFit
        
        toggleButton.setTitle("✨ Ver Shiny", for: .normal)
        toggleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        toggleButton.addTarget(self, action: #selector(toggleShiny), for: .touchUpInside)
        
        statsStack.axis = .vertical
        statsStack.spacing = 8
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        [nameLabel, imageView, toggleButton, typesView, evolutionView, statsStack].forEach {
            stack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
            
        ])
    }
    
    private func bindViewModel() {
        viewModel.didUpdate = { [weak self] in
            DispatchQueue.main.async { self?.updateUI() }
        }
        
        viewModel.didUpdateEvolution = { [weak self] arr in
            DispatchQueue.main.async {
                self?.evolutionView.configure(with: arr)
            }
        }
    }
    
    private func fetchData() {
        guard let id = pokemonId else { return }
        viewModel.fetchPokemonDetail(id: id)
        viewModel.fetchEvolutionSpecies(id: id)
    }
    
    private func updateUI() {
        guard let model = viewModel.pokemon else { return }
        
        nameLabel.text = "#\(model.id) \(model.name.capitalized)"
        normalSpriteURL = model.sprites.front_default
        shinySpriteURL = model.sprites.front_shiny
        
        loadImage(from: normalSpriteURL, into: imageView)
        
        let typeNames = model.types.map { $0.type.name }
        typesView.configure(with: typeNames)
        typesView.onTypeSelected = { [weak self] type in
            self?.showPokemons(ofType: type)
        }
        
        updateStats(model.stats)
    }
    
    private func updateStats(_ stats: [StatEntry]) {
        statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let maxStatValue = 200
        
        for stat in stats {
            let container = UIStackView()
            container.axis = .vertical
            container.spacing = 8
            
            let nameLabel = UILabel()
            nameLabel.text = stat.stat.name.capitalized + ": " + "\(stat.base_stat)"
            nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
            
            let progress = UIProgressView(progressViewStyle: .bar)
            progress.progressTintColor = .systemBlue
            progress.trackTintColor = .systemGray4
            progress.layer.cornerRadius = 4
            progress.clipsToBounds = true
            progress.progress = Float(stat.base_stat) / Float(maxStatValue)
            progress.progressTintColor = color(forStat: stat.stat.name)
            progress.setProgress(0, animated: false)
            progress.transform = CGAffineTransform(scaleX: 1, y: 3)

            UIView.animate(withDuration: 0.8) {
                progress.setProgress(Float(stat.base_stat) / Float(maxStatValue), animated: true)
            }
            container.addArrangedSubview(nameLabel)
            container.addArrangedSubview(progress)
            
            statsStack.addArrangedSubview(container)
        }
    }

    func color(forStat name: String) -> UIColor {
        switch name.lowercased() {
        case "hp": return .systemRed
        case "attack": return .systemOrange
        case "defense": return .systemBlue
        case "special-attack": return .systemPurple
        case "special-defense": return .systemTeal
        case "speed": return .systemGreen
        default: return .systemGray
        }
    }
    private func loadImage(from urlString: String?, into imageView: UIImageView) {
        guard let urlString else { return }
        
        if let cached = imageCache.object(forKey: urlString as NSString) {
            imageView.image = cached
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data, let image = UIImage(data: data) else { return }
            self.imageCache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    @objc private func toggleShiny() {
        showingShiny.toggle()
        
        let nextURL = showingShiny ? shinySpriteURL : normalSpriteURL
        let nextTitle = showingShiny ? "🌙 Ver Normal" : "✨ Ver Shiny"
        toggleButton.setTitle(nextTitle, for: .normal)
        toggleButton.isUserInteractionEnabled = false
        
        UIView.transition(with: imageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve) { [weak self] in
            self?.loadImage(from: nextURL, into: self!.imageView)
        } completion: { [weak self] _ in
            self?.animateImageScale()
            self?.toggleButton.isUserInteractionEnabled = true
        }
    }
    
    private func animateImageScale() {
        UIView.animate(withDuration: 0.2, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.imageView.transform = .identity
            }
        })
    }
    
    private func showPokemons(ofType type: String) {
        delegate?.filterBy(type: type)
        dismiss(animated: true)
    }
}
