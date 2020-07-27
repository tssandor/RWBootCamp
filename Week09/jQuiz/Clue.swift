//
//  QuestionCodable.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

//struct MediaResponse: Codable {
//  var results: [MusicItem]
//}
//
//struct MusicItem: Codable, Identifiable  {
//  let id: Int
//  let artistName: String
//  let trackName: String
//  let collectionName: String
//  let previewUrl: String
//  let artwork: String
//
//  enum CodingKeys: String, CodingKey {
//    case id = "trackId"
//    case artistName
//    case trackName
//    case collectionName
//    case previewUrl
//    case artwork = "artworkUrl100"
//  }
//}

struct ClueResponse: Codable {
  var results: [Clue]
}

struct Clue: Codable {
  let id: Int
  let answer: String
  let question: String
  let categoryID: Int
  let category: Category

  enum CodingKeys: String, CodingKey {
      case id, answer, question
      case categoryID = "category_id"
      case category
  }
}

struct Category: Codable {
    let id: Int
    let title: String
    let cluesCount: Int

    enum CodingKeys: String, CodingKey {
        case id, title
        case cluesCount = "clues_count"
    }
}
//
//
//struct Clue: Codable {
//  let id: Int
//  let answer: String
//  let question: String
//  let category_id: Int
//  let category: Category
//}
//
//struct Category: Codable {
//  let id: Int
//  let title: String
//}
