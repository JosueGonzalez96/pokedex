//
//  NetworkService.swift
//  Pokedex
//
//  Created by Alberto Josue Gonzalez Juarez on 29/10/25.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func fetch<T: Decodable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let data = data else {
                return completion(.failure(NSError(domain: "", code: -1)))
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
