//
//  ViewController.swift
//  Cinema
//
//  Created by Dwistari on 11/03/25.
//

import UIKit

class ViewController: UIViewController {
    
    let movies = ["Inception", "Interstellar", "The Dark Knight", "Avatar", "Titanic"]
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(MovieListTableViewCell.self.self, forCellReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavbar()
        setupView()
    }
    
    
    private func setupNavbar() {
        let searchIcon = UIImage(systemName: "magnifyingglass")
        let tintedSearchIcon = searchIcon?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        title = "Movies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: tintedSearchIcon,
            style: .plain,
            target: self,
            action: #selector(search))

    }
    
    private func setupView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    @objc private func search() {
        
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return movies.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieListTableViewCell
          cell.bindData()
          return cell
      }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Movie: \(movies[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
