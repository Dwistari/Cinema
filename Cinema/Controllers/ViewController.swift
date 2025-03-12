//
//  ViewController.swift
//  Cinema
//
//  Created by Dwistari on 11/03/25.
//

import UIKit

class ViewController: UIViewController {
    
    var movies: [Movie]?
    
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
        setupNavbar()
        setupView()
        viewModel.loadMovies()
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
    
    private func getMovieList() {
        DispatchQueue.main.async {
            self.movies = self.viewModel.movies
            self.tableView.reloadData()
        }
        
    }
    
    
    @objc private func search() {
        
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
