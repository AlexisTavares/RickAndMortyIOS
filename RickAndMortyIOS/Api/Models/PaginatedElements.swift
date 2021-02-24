//
//  PaginatedElements.swift
//  ReferenceCallAPI
//
//  Created by lpiem on 24/02/2021.
//

import Foundation

struct PaginatedElements<Element: Decodable> {
    let information: PaginatinInformation
    let decodedElements: [Element]
}

extension PaginatedElements: Decodable {
    enum CodingKeys: String, CodingKey {
        case information = "info"
        case decodedElements = "results"
    }
}
