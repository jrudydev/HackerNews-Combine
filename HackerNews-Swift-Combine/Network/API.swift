//
//  HackerNewsAPI.swift
//  HackerNews-Swift-Combine
//
//  Created by Rudy Gomez on 2/26/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import Foundation
import Combine

struct API {
  /// API Errors
  enum Error: LocalizedError {
    case addressUnreachable(URL)
    case invalidResponse
    
    var errorDescription: String? {
      switch self {
      case .invalidResponse: return "The server response was invalid."
      case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
      }
    }
  }
  
  /// API EndPoints
  enum EndPoint {
    static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
    
    case story(Int)
    case stories
    
    var url: URL {
      switch self {
      case .story(let id):
        return EndPoint.baseURL.appendingPathComponent("item/\(id).json")
      case .stories:
        return EndPoint.baseURL.appendingPathComponent("newstories.json")
      }
    }
  }
  
  var storyLimit = 10
  
  private let decoder = JSONDecoder()
  
  private let queue = DispatchQueue(label: "com.jrudygomez.HackerNews-Swift-Combine.API")

  // TODO: Add methods for fetching a story and latest stories
}
