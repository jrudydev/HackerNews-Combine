//
//  ViewController.swift
//  HackerNews-Swift-Combine
//
//  Created by Rudy Gomez on 2/26/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import UIKit
import Combine

class StoriesViewController: UITableViewController {
  
  @IBOutlet weak var showingLabel: UILabel!
  
  let newsApi = API()
  
  var subscriptions = Set<AnyCancellable>()
  
  private(set) var newsStories = [Story]() {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  private static var timeFormatter: DateFormatter = {
     let formatter = DateFormatter()
     formatter.dateStyle = .none
     formatter.timeStyle = .short
     return formatter
   }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    newsApi.latestStories()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { print($0) }, receiveValue: {
        self.newsStories = $0
      })
      .store(in: &subscriptions)
  }

  // MARK: - UITabeViewDataSource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.newsStories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "storycell", for: indexPath)
    guard let storyCell = cell as? StoryTableViewCell else { return cell }
    
    let date = Date(timeIntervalSince1970: self.newsStories[indexPath.row].time)
    storyCell.timeLabel?.text = StoriesViewController.timeFormatter.string(from: date)
    storyCell.titleLabel?.text = self.newsStories[indexPath.row].title
    storyCell.subtitleLabel?.text = "By \(self.newsStories[indexPath.row].by)"
    storyCell.linkButton?.setTitle(self.newsStories[indexPath.row].url, for: .normal)
    
    return storyCell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 235
  }
  
}

