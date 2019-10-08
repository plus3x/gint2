//
//  RepositoriesViewController.swift
//  Gint
//
//  Created by Vladislav Petrov on 30/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var service: GitHubRepositoryProvider = GitHubService()
    var repositories = [Repository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadRepositories { repositories in
            self.repositories = repositories
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func reloadRepositories(from offset: Int? = nil, completion: @escaping ([Repository]) -> Void) {
        service.repositories(offset: offset) { result in
            switch result {
            case .success(let repositories):
                completion(repositories)
            case .failure(_): break // swiftlint:disable:this empty_enum_arguments
            }
        }
    }
    
    private func loadMoreItems() {
        reloadRepositories(from: repositories.count) { repositories in
            if repositories.count > 0 {
                self.repositories.append(contentsOf: repositories)
                self.tableView.reloadData()
            }
        }
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier) as! RepositoryTableViewCell
        
        cell.configure(with: repositories[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repositories.count - 1 {
            loadMoreItems()
        }
    }
}
