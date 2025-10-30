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
}

