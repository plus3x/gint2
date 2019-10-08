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
    
    var service: GitHubRepositoryProvider = GitHubReposytoryService()
    var repositories = [Repository]()
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadRepositories { [weak self] repositories in
            guard let self = self else { return }
            
            self.repositories = repositories

            self.tableView.reloadData()
        }
    }
    
    private func reloadRepositories(from offset: Int? = nil, completion: @escaping ([Repository]) -> Void) {
        loading = true
        service.repositories(offset: offset) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let repositories):
                completion(repositories)
            case .failure: break
            }
            self.loading = false
        }
    }
    
    private func loadMoreItems() {
        reloadRepositories(from: repositories.count) { [weak self] repositories in
            guard let self = self else { return }
            guard repositories.count > 0 else { return }
            
            self.repositories.append(contentsOf: repositories)
            self.tableView.reloadData()
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
