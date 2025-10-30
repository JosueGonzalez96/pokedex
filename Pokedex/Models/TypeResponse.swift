//
//  TypeResponse.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import Foundation
struct TypeResponse: Decodable {
    struct PokemonSlot: Decodable {
        struct PokemonRef: Decodable {
            let name: String
            let url: String
        }
        let pokemon: PokemonRef
    }
    let pokemon: [PokemonSlot]
}
