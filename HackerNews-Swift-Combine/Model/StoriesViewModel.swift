//
//  StoriesViewModel.swift
//  HackerNews-Swift-Combine
//
//  Created by Rudy Gomez on 3/13/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import Foundation
import Combine

class StoriesViewModel {
  
  let newsApi = HackerNewsAPI()
  
  var subscriptions = Set<AnyCancellable>()
  
  func fetchStories(_ completion: @escaping ([Story]) -> Void) {
    self.newsApi.latestStories()
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { print($0) }, receiveValue: {
      completion($0)
    })
    .store(in: &subscriptions)
  }
}
