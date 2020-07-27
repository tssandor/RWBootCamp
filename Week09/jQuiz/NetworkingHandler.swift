//
//  NetworkingHandler.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation
// I had to add UIKit since I am downloading an image and returning a UIImage.
// I could just return data and do the decoding in ViewController, but that's messy.
// Not sure what's the best solution here. Is it a big no-go to add UIKit to a handler?
import UIKit

class Networking {
  
  var headerImageURL: String = "https://cdn1.edgedatg.com/aws/v2/abc/ABCUpdates/blog/2900129/8484c3386d4378d7c826e3f3690b481b/1600x900-Q90_8484c3386d4378d7c826e3f3690b481b.jpg"

  static let sharedInstance = Networking()
  
  func getQuestion(completion: @escaping (Int?) -> ()) {
    guard let url = URL(string: "http://www.jservice.io/api/random") else {
      print("Couldn't set the URL :]")
      fatalError()
    }
    URLSession.shared.dataTask(with: url) {data, response, taskError in
      guard let httpResponse = response as? HTTPURLResponse,
        (200..<300).contains(httpResponse.statusCode),
        let data = data else {
          print("Received an error from httpResponse")
          return
      }
      let decoder = JSONDecoder()
      guard let clue = try? decoder.decode([Clue].self, from: data) else {
        print("Got the data from the API but can't decode the JSON :[")
        return
      }
      completion(clue[0].categoryID)
    }.resume()
    
  }
  
  func getMoreAnswersForCategory(categoryID: Int, completion: @escaping ([Clue]) -> ()) {
    guard let url = URL(string: "http://www.jservice.io/api/clues/?category=\(categoryID)") else {
      print("Couldn't set the URL for a particular category :]")
      fatalError()
    }
    URLSession.shared.dataTask(with: url) {data, response, taskError in
    guard let httpResponse = response as? HTTPURLResponse,
      (200..<300).contains(httpResponse.statusCode),
      let data = data else {
        print("Received an error from httpResponse when querying more answers")
        return
      }
      let decoder = JSONDecoder()
      guard let clues = try? decoder.decode([Clue].self, from: data) else {
        print("Couldn't decode the answers")
        return
      }
      completion(clues)
    }.resume()
  }

  func getHeaderImage(completion: @escaping (UIImage?) -> ()) {
    guard let headerImageUrl = URL(string: headerImageURL) else {
      return
    }
    _ = URLSession.shared.downloadTask(with: headerImageUrl) { location, response, error in
      guard let location = location,
            let imageData = try? Data(contentsOf: location),
        let image = UIImage(data: imageData) else {
          print("Tried to decode the header image from data but failed")
          return
      }
      completion(image)
    }.resume()
  }
  
}
