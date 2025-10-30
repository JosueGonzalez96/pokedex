//
//  PokemonListResponse.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonEntry]
}
