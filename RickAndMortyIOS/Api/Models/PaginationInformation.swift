//
//  PaginationInformation.swift
//  ReferenceCallAPI
//
//  Created by lpiem on 24/02/2021.
//

import Foundation

struct PaginatinInformation {
    let count: Int
    let pages: Int
    let nextURL: URL?
    let previousURL: URL?
}

extension PaginatinInformation: Decodable {
    enum CodingKeys: String, CodingKey {
        case count
        case pages
        case nextURL = "next"
        case previousURL = "prev"
    }
}
