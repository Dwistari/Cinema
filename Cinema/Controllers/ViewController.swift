//
//  ViewController.swift
//  Cinema
//
//  Created by Dwistari on 11/03/25.
//

import UIKit

class ViewController: UIViewController {
    
    var movies: [Movie]?
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.tintColor = UIColor.gray
        searchBar.backgroundImage = UIImage()
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(MovieListTableViewCell.self.self, forCellReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var viewModel: MovieListViewModel = {
        let viewModel = MovieListViewModel()
        viewModel.getMovieData = getMovieList
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        viewModel.loadMovies()
    }
    
    private func setupView() {
        title = "Movie"
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getMovieList() {
        DispatchQueue.main.async {
            self.movies = self.viewModel.movies
            self.tableView.reloadData()
        }
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieListTableViewCell
          cell.bindData(data: movies?[indexPath.row])
          return cell
      }
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.movie = movies?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         if !searchText.isEmpty {
             viewModel.searchMovies(keyword: searchText)
         }
         tableView.reloadData()
     }
}
