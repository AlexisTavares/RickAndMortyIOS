//
//  ViewController.swift
//  ReferenceCallAPI
//
//  Created by lpiem on 27/01/2021.
//

import UIKit

class CharacterViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    private var serieCharacters : [SerieCharacter] = []
    private var nextUrl: URL!
    
    private enum Section {
        case characterSection
    }
    
    private enum Item: Hashable {
        case character(SerieCharacter)
    }
    
    private var diffableDataSource: UITableViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        diffableDataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
                case .character(let serieCharacter):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                    cell.textLabel?.text = serieCharacter.name
                    cell.imageView?.loadImage(from: serieCharacter.imageURL) {
                        cell.setNeedsLayout()
                    }
                    cell.detailTextLabel?.text =  serieCharacter.species
                    return cell
            }
        })
        
        let snapshot = createSnapshot(serieCharacters: [])
        diffableDataSource.apply(snapshot)
        
        getCharacters(url: nil)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.getCharacters(url: self.nextUrl)
    }
    private func getCharacters(url: URL?){
        NetworkManager.shared.fetchCharacters(from: url) { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let paginatedElements):
                    self.serieCharacters = paginatedElements.decodedElements
                    self.nextUrl = paginatedElements.information.nextURL
                    let snapshot = self.createSnapshot(serieCharacters: self.serieCharacters)
                    
                    DispatchQueue.main.async {
                        self.diffableDataSource.apply(snapshot)
                    }
            }
        }
    }
    private func createSnapshot(serieCharacters: [SerieCharacter]) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.characterSection])
        
        let items = serieCharacters.map(Item.character)
        
        snapshot.appendItems(items, toSection: .characterSection)
        
        return snapshot
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.isEmpty)
        {
            let snapshot = createSnapshot(serieCharacters: serieCharacters)
            diffableDataSource.apply(snapshot)
        }
        else {
            let tempCharacters = serieCharacters.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            let snapshot = createSnapshot(serieCharacters: tempCharacters)
            diffableDataSource.apply(snapshot)
        }
        tableView.reloadData()
    }
}

extension CharacterViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "detail":
            let nav = segue.destination as! UINavigationController
            let characterDetailViewController = nav.topViewController as! CharacterDetailViewController
            let selectedCharacter = serieCharacters[tableView.indexPath(for: sender as! UITableViewCell)!.item]
            characterDetailViewController.character = selectedCharacter
            break
        default:
            return
        }
    }
}
