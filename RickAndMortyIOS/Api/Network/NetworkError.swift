//
//  NetworkError.swift
//  RickAndMortyIOS
//
//  Created by lpiem on 24/02/2021.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case statusCode(Int)
    case mimeType
    case emptyData
}
