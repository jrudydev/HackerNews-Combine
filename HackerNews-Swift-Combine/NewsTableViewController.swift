//
//  ViewController.swift
//  HackerNews-Swift-Combine
//
//  Created by Rudy Gomez on 2/26/20.
//  Copyright © 2020 JRudy Gaming. All rights reserved.
//

import UIKit
import Combine

class NewsTableViewController: UITableViewController {
  
  let newsApi = API()
  
  var subscriptions = Set<AnyCancellable>()
  
  private(set) var newsStories = [Story]() {
    didSet {
      self.tableView.reloadData()
    }
  }

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
    let cell = tableView.dequeueReusableCell(withIdentifier: "newscell", for: indexPath)
    cell.textLabel?.text = self.newsStories[indexPath.row].title
    cell.detailTextLabel?.text = "By \(self.newsStories[indexPath.row].by)"
    
    return cell
  }
  
}

