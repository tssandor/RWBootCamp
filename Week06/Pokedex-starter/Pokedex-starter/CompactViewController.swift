/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CompactViewController: UIViewController {
  
  // Hi Jay,
  // This all works, but I get a lot of warnings in the console about
  // constraints issues. I've tried to fix this but I kinda can't O_o
  
  enum Section {
    case main
  }

  @IBOutlet weak var compactCollectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    compactCollectionView.collectionViewLayout = configureLayout()
    setupPokemonData()
  }

  func configureLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.33))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func setupPokemonData() {
    let pokemons = PokemonGenerator.shared.generatePokemons()
    
    dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: compactCollectionView) { (collectionView, indexPath, number) -> UICollectionViewCell? in
      
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as? PokemonCell else {
        fatalError("Cannot create new cell")
      }
      
      cell.pokemonNameLabel.text = pokemons[indexPath.row].pokemonName
      cell.pokemonImage.image = UIImage(named: String(indexPath.row + 1))
      
      return cell
    }
    
    var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Int>()
    initialSnapshot.appendSections([.main])
    initialSnapshot.appendItems(Array(1...pokemons.count))
    
    dataSource.apply(initialSnapshot, animatingDifferences: false)
    
  }
  
}
