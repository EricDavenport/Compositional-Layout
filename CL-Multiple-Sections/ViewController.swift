//
//  ViewController.swift
//  CL-Multiple-Sections
//
//  Created by Eric Davenport on 8/18/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // 1
  enum Section: Int, CaseIterable {
    case grid
    case single
    // TODO: Add a third section
    var columnCount: Int {
      switch self { // self represents instance of the enum
      case .grid:
        return 4  // 4 columns
      case .single:
        return 1  // 1 column
      }
    }
  }
  
  // 2
  @IBOutlet weak var collectionView: UICollectionView!  // default layout is flow layout
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>  // both arguments have  to confoorm to Hashable
  
  private var dataSource: DataSource!  // using typeaalias - no longer have to use -->> UICollectionViewDiffableDataSource<Section, Int>
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    configureDataSource()
  }
  
  // 4
  private func configureCollectionView() {
    // overwrite the defsault layout from flow layout to compositional Layout
    // if done progrommatically
    // collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.collectionViewLayout = createLayout()
    collectionView.backgroundColor = .systemGroupedBackground
    
    // register the supplementary Headerview
    collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
  }
  
  // 3
  private func createLayout() -> UICollectionViewLayout {
//    let layout = UICollectionViewCompositionalLayout(section: Section)
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      
      // find out what section we are working with
      guard let sectionType = Section(rawValue: sectionIndex) else {
        return nil
      }
      
      // how many columns
      let columns = sectionType.columnCount  // 1 or 4 columns
      
      // the the item's container => group
      // create the layou: item -> group -> section -> layout
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      // TODO: ad content insets for item
      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
      
      // whats the groups container => section
      let groupHeight = columns == 1 ? NSCollectionLayoutDimension.absolute(200) :
        NSCollectionLayoutDimension.fractionalWidth(0.25)
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
      
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)  // columns can be 1 or 4
      
      let section = NSCollectionLayoutSection(group: group)
      
      // size options: .fractional, .absolute, .estimated
      // configure the header view
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
      
      section.boundarySupplementaryItems = [header]
      return section
    }
    return layout
  }
  
  
  // 5
  private func configureDataSource() {
    dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
      // 1
      // configure cell
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as? LabelCell else {
        fatalError("could not dequeue a LabelCell")
      }
      cell.textLabel.text = "\(item)"
      
      if indexPath.section == 0 {  // first section
        cell.backgroundColor = .systemPink
        cell.layer.cornerRadius = 12
      } else {
        cell.backgroundColor = .systemYellow
        cell.layer.cornerRadius = 0
      }
      
      return cell
    })
    
    // 3
    // setup headerView supplementaryViewProvider
    dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
      guard let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
        fatalError("could not dequeue a HeaderView")
      }
      headerView.textLabel.text = "\(Section.allCases[indexPath.section])".capitalized
      return headerView
    }
    
    // 2
    // setup initial snapshot
    var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
    snapshot.appendSections([.grid, .single])
    snapshot.appendItems(Array(1...12), toSection: .grid)
    snapshot.appendItems(Array(13...20), toSection: .single)
    dataSource.apply(snapshot, animatingDifferences: false)
    
  }
  


}

