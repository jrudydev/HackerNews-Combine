//
//  HackerNewsAPI.swift
//  HackerNews-Swift-Combine
//
//  Created by Rudy Gomez on 2/26/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import Foundation
import Combine

struct HackerNewsAPI {
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

  func story(id: Int) -> AnyPublisher<Story, Error> {
    URLSession.shared
      .dataTaskPublisher(for: EndPoint.story(id).url)
      .receive(on: queue)
      .map(\.data)
      .decode(type: Story.self, decoder: decoder)
      .catch { _ in Empty<Story, Error>() }
      .eraseToAnyPublisher()
  }
  
  func mergedStories(ids: [Int]) -> AnyPublisher<Story, Error> {
    let storyIDs = Array(ids.prefix(storyLimit))
    
    precondition(!ids.isEmpty)
    
    let initialPublisher = story(id: storyIDs[0])
    let remainder = Array(storyIDs.dropFirst())
    
    return remainder.reduce(initialPublisher) { combined, id in
      return combined
        .merge(with: story(id: id))
      .eraseToAnyPublisher()
    }
  }
  
  func latestStories() -> AnyPublisher<[Story], Error> {
    URLSession.shared
      .dataTaskPublisher(for: EndPoint.stories.url)
      .map(\.data)
      .decode(type: [Int].self, decoder: decoder)
      .mapError { error -> HackerNewsAPI.Error in
        switch error {
        case is URLError:
          return Error.addressUnreachable(EndPoint.stories.url)
        default:
          return Error.invalidResponse
        }
      }
      .filter { !$0.isEmpty }
      .flatMap { storyIDs in
        self.mergedStories(ids: storyIDs)
      }
      .scan([]) { stories, story -> [Story] in
        return stories + [story]
      }
      .map { $0.sorted() }
      .eraseToAnyPublisher()
  }
}
