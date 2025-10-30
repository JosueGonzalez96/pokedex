//
//  EvolutionChain.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 30/10/25.
//

import Foundation
struct EvolutionChain: Codable {
    let url: String
    var id: Int {
        Int(url.split(separator: "/").last!) ?? 0
    }
}
