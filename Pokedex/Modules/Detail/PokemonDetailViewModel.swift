//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import Foundation

final class PokemonDetailViewModel {
    private(set) var pokemon: PokemonDetail?
    var didUpdate: (() -> Void)?
    var didUpdateEvolution: ((_ evolutions: [Int]) -> Void)?
    
    func fetchPokemonDetail(id: Int) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else { return }
        NetworkService.shared.fetch(url) { (result: Result<PokemonDetail, Error>) in
            switch result {
            case .success(let data):
                self.pokemon = data
                self.didUpdate?()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func fetchEvolutionChain(for id: Int) {
        guard let speciesURL = URL(string: "https://pokeapi.co/api/v2/evolution-chain/\(id)") else { return }
        NetworkService.shared.fetch(speciesURL) { [weak self] (result: Result<EvolutionChainResponse, Error>) in
            switch result {
            case .success(let data):
                print(data)
                var arr: [Int] = []
                
                for evolution in data.chain.evolves_to {
                    arr.append(evolution.species.id)
                }
                if let nextEvolutionId = data.chain.evolves_to.first?.evolves_to.first?.species.id {
                    arr.append(nextEvolutionId)
                }
                arr.append(data.chain.species.id)
                arr.sort()
                self?.didUpdateEvolution?(arr)
                
            case .failure(let error):
                print("Error en species:", error)
            }
        }
    }
    
    func fetchEvolutionSpecies(id: Int) {
        guard let speciesURL = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(id)") else { return }
        NetworkService.shared.fetch(speciesURL) {[weak self] (result: Result<EvolutionSpecies, Error>) in
            switch result {
            case .success(let data):
                print(data)
                self?.fetchEvolutionChain(for: data.evolutionChain.id)
            case .failure(let error):
                print("Error en species:", error)
            }
        }
    }
}
