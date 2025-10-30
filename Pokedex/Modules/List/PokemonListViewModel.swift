//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import Foundation

final class PokemonListViewModel {
    private(set) var pokemons: [PokemonEntry] = []
    var didUpdate: (() -> Void)?
    var didUpdateFilter: ((_ filterBy: String) -> Void)?
    var didUpdatehideFilter: (() -> Void)?
    
    func fetchPokemons() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20") else { return }
        NetworkService.shared.fetch(url) { [weak self] (result: Result<PokemonListResponse, Error>) in
            switch result {
            case .success(let data):
                self?.pokemons = data.results
                self?.didUpdate?()
                self?.didUpdatehideFilter?()
            case .failure(let error):
                self?.didUpdateFilter?("No encontramos resultados\nError:\(error.localizedDescription.capitalized)")
            }
        }
    }
    
    func searchByType(_ type: String) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/type/\(type)") else { return }
        self.didUpdateFilter?("Buscando: \(type.capitalized)")
        NetworkService.shared.fetch(url) {[weak self] (result: Result<TypeResponse, Error>) in
            switch result {
            case .success(let data):
                let limited = Array(data.pokemon.prefix(20))
                self?.pokemons = limited.map { entry in
                    PokemonEntry(name: entry.pokemon.name, url: entry.pokemon.url)
                }
                self?.didUpdate?()
            case .failure(_):
                self?.didUpdateFilter?("No se encontro el tipo: \(type)")
            }
        }
    }
    
    func fetchSinglePokemon(identifier: String) {
        if identifier.isEmpty {
            fetchPokemons()
        }
        self.didUpdateFilter?("Buscando: \(identifier.capitalized)")
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(identifier)") else { return }
        NetworkService.shared.fetch(url) {[weak self] (result: Result<PokemonDetail, Error>) in
            switch result {
            case .success(let data):
                let entry = PokemonEntry(name: data.name, url: "https://pokeapi.co/api/v2/pokemon/\(data.id)/")
                self?.pokemons = [entry]
                self?.didUpdate?()
            case .failure:
                self?.pokemons = []
                self?.didUpdate?()
                self?.didUpdateFilter?("Pokemon no encontrado")
            }
        }
    }
}
