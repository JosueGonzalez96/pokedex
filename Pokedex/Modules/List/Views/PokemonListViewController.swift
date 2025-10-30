//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import UIKit

final class PokemonListViewController: UIViewController, UISearchBarDelegate {
    
    let viewModel = PokemonListViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.isHidden = true
        return label
    }()
    private let buttonFilter: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Limpiar filtros", for: .normal)
        button.tintColor = .systemBlue
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokedex"
        view.backgroundColor = .systemBackground
         
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        tableView.rowHeight = 120
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(filterLabel)
        view.addSubview(buttonFilter)
                
        setupConstrains()
        actions()
        
        viewModel.fetchPokemons()
    }
    func setupConstrains() {
        buttonFilter.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonFilter.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 4),
            buttonFilter.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonFilter.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonFilter.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: buttonFilter.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func actions() {
        buttonFilter.addTarget(self, action: #selector(clearFiltersTapped), for: .touchUpInside)
        viewModel.didUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.didUpdateFilter = { [weak self] filterBy in
            self?.showFilterLabel(text: filterBy)
        }
        viewModel.didUpdatehideFilter = { [weak self] in
            self?.hideFilterLabel()
        }
    }
    @objc private func clearFiltersTapped() {
        hideFilterLabel()
        buttonFilter.isHidden = true
        searchBar.text = ""
        viewModel.fetchPokemons()
    }

    private func showFilterLabel(text: String) {
        filterLabel.text = text
           UIView.animate(withDuration: 0.25) {
               self.filterLabel.isHidden = false
               self.buttonFilter.isHidden = false
               self.filterLabel.alpha = 1
               self.buttonFilter.alpha = 1
           }
    }

    private func hideFilterLabel() {
        UIView.animate(withDuration: 0.25) {
                self.filterLabel.alpha = 0
                self.buttonFilter.alpha = 0
            } completion: { _ in
                self.filterLabel.isHidden = true
                self.buttonFilter.isHidden = true
            }
    }
}

extension PokemonListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }
        let pokemon = viewModel.pokemons[indexPath.row]
        cell.configure(with: pokemon)
        
        return cell
    }
}
extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = viewModel.pokemons[indexPath.row]
        let vc = PokemonDetailViewController()
        vc.pokemonId = selected.id
        vc.delegate = self
        show(vc, sender: nil)
    }
}

extension PokemonListViewController: PokemonDetailDelegate {
    func filterBy(type: String) {
        viewModel.searchByType(type)
    }
}
extension PokemonListViewController {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.lowercased(), !text.isEmpty else { return }
        searchByNameOrNumber(text)
    }
    
    func searchByNameOrNumber(_ query: String) {
        if let id = Int(query) {
            self.viewModel.fetchSinglePokemon(identifier: "\(id)")
        } else {
            self.viewModel.fetchSinglePokemon(identifier: query)
        }
    }
}
