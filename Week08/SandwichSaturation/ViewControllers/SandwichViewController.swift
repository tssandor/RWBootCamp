//
//  SandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit
import CoreData

protocol SandwichDataSource {
  func saveSandwich(_: SandwichData)
}

class SandwichViewController: UITableViewController, SandwichDataSource {
  let searchController = UISearchController(searchResultsController: nil)
  var sandwiches = [SandwichData]()
  var filteredSandwiches = [SandwichData]()
  let defaults = UserDefaults.standard
  
  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    loadSandwiches()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddView(_:)))
    navigationItem.rightBarButtonItem = addButton
    
    // Setup Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Filter Sandwiches"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    searchController.searchBar.scopeButtonTitles = SauceAmount.allCases.map { $0.rawValue }
    searchController.searchBar.delegate = self
    
    // *** HOMEWORK COMMENT ***
    // We initialize the searchbar scope from user defaults.
    // If it doesn't exist, the fallback default value is 0, which is exactly what we need.
    searchController.searchBar.selectedScopeButtonIndex = defaults.integer(forKey: "selectedScope")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func loadSandwiches() {
    
    // *** HOMEWORK COMMENT ***
    // WHY DISTRIBUTE SEED DATA LIKE THIS?
    // The best answer is probably that seed data can change between app versions.
    // So in real like, you'd want to load a JSON from a remote server (so not bundled with the app).
    // This way you can always supply the app with the most up-to-date seed.
    
    // *** HOMEWORK COMMENT ***
    // ALSO, WHAT'S HAPPENING HERE?
    // I decided to take a slightly easier approach and used Hacking with Swift's general JSON decoder extension
    // See https://www.hackingwithswift.com/example-code/system/how-to-decode-json-from-your-app-bundle-the-easy-way
    // It adds an extension to Bundle (see the very end of this file), and makes it possible to load and decode
    // a JSON with one line.
 
    //THIS
//    let sandwichesArrayFromJSONSeed = Bundle.main.decode([SandwichData].self, from: "sandwiches.json")

    // *** HOMEWORK COMMENT ***
    // While browsing the DB with an SQLite inspector I realized the DB is not cleared between app launches.
    // So if we start the app 100 times we will have 1000 sandwiches in the DB!
    // Not very efficient :] And since we initialize the DB from a JSON, it's safe to start from scratch every time.
    // So let's clear the DB first!
    
//    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Sandwich.fetchRequest())
//    do {
//      try context.execute(batchDeleteRequest)
//    }  catch let error as NSError {
//      print("Issue with resetting the Core Data DB. \(error), \(error.userInfo)")
//    }

    // *** HOMEWORK COMMENT ***
    // And now, let's write everything we have in the JSON to Core Data.
    // After this runs, the app works as expected:
    // 1. We parse the JSON
    // 2. We clear the Core Data DB to make sure we don't end up with a bloated mess.
    // 3. We take whatever is in the JSON and write it to the DB.
    // This can be cross-checked using an SQLite browser, which I did.
    
    //THIS
//    for data in sandwichesArrayFromJSONSeed {
//      addASandwichToDB(data)
    
    
    
//      let sandwichToSave = Sandwich(entity: Sandwich.entity(), insertInto: context)
//      sandwichToSave.name = data.name
//      sandwichToSave.imageName = data.imageName
//      if data.sauceAmount == .none {
//        sandwichToSave.sauceAmount = ".none"
//      } else {
//        sandwichToSave.sauceAmount = ".tooMuch"
//      }
//      appDelegate.saveContext()
//      sandwiches.append(SandwichData(name: data.name, sauceAmount: data.sauceAmount, imageName: data.imageName))
    //THIS
//    }
    
    let request = NSFetchRequest<Sandwich>(entityName: "Sandwich")
    let sort = NSSortDescriptor(key: "name", ascending: true)
    request.sortDescriptors = [sort]

    do {
      let sandwichesToFetch = try appDelegate.persistentContainer.viewContext.fetch(request)
      print(sandwichesToFetch)
      for sandwichFromDB in sandwichesToFetch {
        var sauceOption: SauceAmount
        if sandwichFromDB.sauceAmount == ".none" {
          sauceOption = .none
        } else {
          sauceOption = .tooMuch
        }
        sandwiches.append(SandwichData(name: sandwichFromDB.name!, sauceAmount: sauceOption, imageName: sandwichFromDB.imageName!))
      }
    } catch {
        print("Fetch failed")
    }
  }

  func saveSandwich(_ sandwich: SandwichData) {
    addASandwichToDB(sandwich)
    // THIS IS THE LOCAL DB
//    sandwiches.append(sandwich)
    tableView.reloadData()
  }
  
  func addASandwichToDB(_ data: SandwichData) {
    let sandwichToSave = Sandwich(entity: Sandwich.entity(), insertInto: context)
    sandwichToSave.name = data.name
    sandwichToSave.imageName = data.imageName
    if data.sauceAmount == .none {
      sandwichToSave.sauceAmount = ".none"
    } else {
      sandwichToSave.sauceAmount = ".tooMuch"
    }
    appDelegate.saveContext()
    // THIS IS THE LOCAL DB
    sandwiches.append(SandwichData(name: data.name, sauceAmount: data.sauceAmount, imageName: data.imageName))
  }

  @objc
  func presentAddView(_ sender: Any) {
    performSegue(withIdentifier: "AddSandwichSegue", sender: self)
  }
  
  // MARK: - Search Controller
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func filterContentForSearchText(_ searchText: String,
                                  sauceAmount: SauceAmount? = nil) {
    filteredSandwiches = sandwiches.filter { (sandwhich: SandwichData) -> Bool in
      let doesSauceAmountMatch = sauceAmount == .any || sandwhich.sauceAmount == sauceAmount

      if isSearchBarEmpty {
        return doesSauceAmountMatch
      } else {
        return doesSauceAmountMatch && sandwhich.name.lowercased()
          .contains(searchText.lowercased())
      }
    }
    tableView.reloadData()
  }
  
  var isFiltering: Bool {
    let searchBarScopeIsFiltering =
      searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive &&
      (!isSearchBarEmpty || searchBarScopeIsFiltering)
  }
  
  // MARK: - Table View
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFiltering ? filteredSandwiches.count : sandwiches.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "sandwichCell", for: indexPath) as? SandwichCell
      else { return UITableViewCell() }
    
    let sandwich = isFiltering ?
      filteredSandwiches[indexPath.row] :
      sandwiches[indexPath.row]

    cell.thumbnail.image = UIImage.init(imageLiteralResourceName: sandwich.imageName)
    cell.nameLabel.text = sandwich.name
    cell.sauceLabel.text = sandwich.sauceAmount.description

    return cell
  }
}

// MARK: - UISearchResultsUpdating
extension SandwichViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let sauceAmount = SauceAmount(rawValue:
      searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])

    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
  }
}

// MARK: - UISearchBarDelegate
extension SandwichViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
    
    // *** HOMEWORK COMMENT ***
    // We store the current scope to User Defaults so it persists
    defaults.set(selectedScope, forKey: "selectedScope")
    
    let sauceAmount = SauceAmount(rawValue: searchBar.scopeButtonTitles![selectedScope])
    filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
  }
}

// Bundle extension from Hacking with Swift
extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
