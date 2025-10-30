//
//  Species.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import Foundation

struct Species: Decodable {
    let name: String
    let url: String
    
    var id: Int {
        Int(url.split(separator: "/").last!) ?? 0
    }
}
