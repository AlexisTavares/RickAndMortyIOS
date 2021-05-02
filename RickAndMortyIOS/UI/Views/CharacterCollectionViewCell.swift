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
        imageView.loadImage(from: character.imageURL){
            self.setNeedsLayout()
        }
        imageView.layer.cornerRadius = 15.0
        imageView.clipsToBounds = true
        nameLabel.text = character.name
    }
}
