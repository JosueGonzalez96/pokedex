//
//  TypeColors.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import UIKit

struct TypeColors {
    static func color(for type: String) -> UIColor {
        switch type {
        case "fire": return .systemRed
        case "water": return .systemBlue
        case "grass": return .systemGreen
        case "electric": return .systemYellow
        case "bug": return .systemTeal
        case "psychic": return .systemPurple
        case "ground": return .brown
        case "rock": return .darkGray
        case "fairy": return .systemPink
        case "fighting": return .systemOrange
        case "ghost": return .systemIndigo
        case "dragon": return .systemCyan
        case "ice": return .cyan
        case "poison": return .magenta
        case "flying": return .systemMint
        default: return .lightGray
        }
    }
}
