//
//  ViewController.swift
//  RickAndMortyIOS
//
//  Created by lpiem on 24/02/2021.
//

import UIKit

class ViewController: UITableViewController {
    private enum Section {
        case main
    }

    private enum Item: Hashable {
        case character(SerieCharacter)
    }

    private var diffableDataSource: UITableViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()

        diffableDataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .character(let serieCharacter):
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = serieCharacter.name
                cell.imageView?.loadImage(from: serieCharacter.imageURL) {
                    cell.setNeedsLayout()
                }
                cell.detailTextLabel?.text = DateFormatter.localizedString(from: serieCharacter.createdDate,
                                                                           dateStyle: .medium,
                                                                           timeStyle: .short)
                return cell
            }
        })

        let snapshot = createSnapshot(serieCharacters: [])
        diffableDataSource.apply(snapshot)

        NetworkManager.shared.fetchCharacters { (result) in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let paginatedElements):
                let serieCharacters = paginatedElements.decodedElements
                let snapshot = self.createSnapshot(serieCharacters: serieCharacters)

                DispatchQueue.main.async {
                    self.diffableDataSource.apply(snapshot)
                }
            }
        }
    }

    private func createSnapshot(serieCharacters: [SerieCharacter]) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])

        let items = serieCharacters.map(Item.character)

        snapshot.appendItems(items, toSection: .main)

        return snapshot
    }
}

