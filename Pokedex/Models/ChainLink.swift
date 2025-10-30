//
//  ChainLink.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import Foundation
struct ChainLink: Decodable {
    let species: Species
    let evolves_to: [ChainLink]
}
