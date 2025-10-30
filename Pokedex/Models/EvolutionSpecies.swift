//
//  EvolutionSpecies.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 30/10/25.
//

import Foundation

struct EvolutionSpecies: Codable {
    let evolutionChain: EvolutionChain
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
}
