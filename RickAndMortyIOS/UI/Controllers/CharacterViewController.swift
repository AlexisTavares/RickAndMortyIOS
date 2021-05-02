//
//  ViewController.swift
//  ReferenceCallAPI
//
//  Created by lpiem on 27/01/2021.
//

import UIKit

class CharacterViewController: UICollectionViewController, UISearchBarDelegate {
    var searchController = UISearchController(searchResultsController: nil)

    private var serieCharacters : [SerieCharacter] = []
    private var sortedCharacters : [SerieCharacter] = []
    private var isSearchingCharacter = false
    private var nextUrl: URL!
    
    private enum Section {
        case characterSection
    }
    
    private enum Item: Hashable {
        case character(SerieCharacter)
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        self.navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        super.viewDidLoad()

        diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
                case .character(let serieCharacter):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CharacterCollectionViewCell
                    cell.setupWithCharacter(character: serieCharacter)
                    return cell
            }
        })
        
        let snapshot = createSnapshot(serieCharacters: serieCharacters)
        diffableDataSource.apply(snapshot)

        getCharacters(url: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == serieCharacters.count - 1 {
            self.getCharacters(url: self.nextUrl)
        }
    }
    
    private func getCharacters(url: URL?){
        NetworkManager.shared.fetchCharacters(from: url) { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let paginatedElements):
                    self.serieCharacters.append(contentsOf: paginatedElements.decodedElements)
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
            isSearchingCharacter = false
            let snapshot = createSnapshot(serieCharacters: serieCharacters)
            diffableDataSource.apply(snapshot)
        }
        else {
            sortedCharacters = serieCharacters.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            let snapshot = createSnapshot(serieCharacters: sortedCharacters)
            diffableDataSource.apply(snapshot)
        }
        isSearchingCharacter = true
        collectionView.reloadData()
    }
}

extension CharacterViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "detail":
            let nav = segue.destination as! UINavigationController
            let characterDetailViewController = nav.topViewController as! CharacterDetailViewController
            if (isSearchingCharacter){
                let selectedCharacter = sortedCharacters[collectionView.indexPath(for: sender as! UICollectionViewCell)!.item]
                characterDetailViewController.character = selectedCharacter
            }
            else{
                let selectedCharacter = serieCharacters[collectionView.indexPath(for: sender as! UICollectionViewCell)!.item]
                characterDetailViewController.character = selectedCharacter
            }
            break
        default:
            return
        }
    }
}
