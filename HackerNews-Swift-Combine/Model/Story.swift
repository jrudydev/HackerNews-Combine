//
//  Story.swift
//  HackerNews-Swift-Combine
//
//  Created by Rudy Gomez on 2/26/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import Foundation

struct Story: Codable, Hashable {
  let id: Int
  let title: String
  let by: String
  let time: TimeInterval
  let url: String
}

extension Story: Comparable {
  public static func < (lhs: Story, rhs: Story) -> Bool {
    return lhs.time > rhs.time
  }
}

extension Story: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "\nStory\nTitle: \(title)\nBy: \(by)\nURL: \(url)\n-----"
  }
}
