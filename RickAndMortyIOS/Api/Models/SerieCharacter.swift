//
//  Result.swift
//  ReferenceCallAPI
//
//  Created by lpiem on 27/01/2021.
//

import Foundation

struct SerieCharacter : Hashable{
    let identifier: Int
    let name: String
    let imageURL : URL
    let createdDate: Date
    let species : String
    let gender : String
    
    func contains(query: String?) -> Bool{
        guard let query = query
        else {
            return true
            
        }
        guard !query.isEmpty
        else {
            return true
            
        }
        let lowerCasedQuery = query.lowercased()
        return name.lowercased().contains(lowerCasedQuery)
    }
}

extension SerieCharacter: Decodable{
    enum CodingKeys: String, CodingKey{
        case identifier = "id"
        case name = "name"
        case imageURL = "image"
        case createdDate = "created"
        case species = "species"
        case gender = "gender"
    }
}
