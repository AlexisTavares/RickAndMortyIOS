//
//  NetworkManager.swift
//  RickAndMortyIOS
//
//  Created by lpiem on 24/02/2021.
//

import Foundation

class NetworkManager {
    // MARK: - Properties

    static let shared = NetworkManager()

    private let baseURL = URL(string: "https://rickandmortyapi.com/api/")!

    private static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    // MARK: - Initializer

    private init() { }

    // MARK: - Public Methods

    func fetchCharacters(completion: @escaping (Result<PaginatedElements<SerieCharacter>, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("character")
        let request = URLRequest(url: url)
        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpReponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard (200...299).contains(httpReponse.statusCode) else {
                completion(.failure(NetworkError.statusCode(httpReponse.statusCode)))
                return
            }

            guard let mimeType = httpReponse.mimeType,
                  mimeType == "application/json" else {
                completion(.failure(NetworkError.mimeType))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .custom { (decoder) -> Date in
                    let dateString = try decoder.singleValueContainer().decode(String.self)
                    return NetworkManager.iso8601Formatter.date(from: dateString)!
                }

                let result = try jsonDecoder.decode(PaginatedElements<SerieCharacter>.self, from: data)

                completion(.success(result))

            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
