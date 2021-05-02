//
//  CharacterDetailViewController.swift
//  RickAndMortyIOS
//
//  Created by lpiem on 02/05/2021.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    var character: SerieCharacter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = character.name
        speciesLabel.text = character.species
        genderLabel.text = character.gender
        creationDateLabel.text = DateFormatter.localizedString(from: character.createdDate,
                                                               dateStyle: .medium,
                                                               timeStyle: .short)
        imageView.loadImage(from: character.imageURL, completion: nil)
    }
}
