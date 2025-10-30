//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import Foundation
struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let sprites: Sprite
    let types: [TypeEntry]
    let stats: [StatEntry]
    let cries: Cries
}
struct Cries: Decodable {
    let latest: String
}
struct Sprite: Decodable {
    let front_default: String?
    let front_shiny: String?
}
struct TypeEntry: Decodable {
    struct type: Decodable {
        let name: String
    }
    let type: type
}
struct StatEntry: Decodable {
    struct Stat: Decodable {
        let name: String
    }
    let base_stat: Int
    let stat: Stat
}
