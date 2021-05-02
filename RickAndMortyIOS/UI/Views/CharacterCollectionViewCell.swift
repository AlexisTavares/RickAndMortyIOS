//
//  CharacterCollectionViewCell.swift
//  RickAndMortyIOS
//
//  Created by lpiem on 02/05/2021.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    func setupWithCharacter(character: SerieCharacter){
        imageView.loadImage(from: character.imageURL, completion: nil)
        nameLabel.text = character.name
    }
}
