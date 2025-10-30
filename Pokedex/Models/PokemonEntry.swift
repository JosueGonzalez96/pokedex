//
//  PokemonEntry.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import Foundation

struct PokemonEntry: Decodable {
    let name: String
    let url: String
    
    var id: Int {
        Int(url.split(separator: "/").last!) ?? 0
    }
    
    var imageUrl: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }
}
