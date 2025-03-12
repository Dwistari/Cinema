//
//  ViewController.swift
//  Cinema
//
//  Created by Dwistari on 11/03/25.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var movies: [Movie]?
    var currentPage = 1
    
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
    
    private let viewModel = MovieListViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        loadMoviesList()
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
    
    private func loadMoviesList() {
        viewModel.movies
            .subscribe(onNext: { movies in
                self.movies = movies
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .subscribe(onNext: { error in
                print("Error:", error)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .map { [weak self] contentOffset in
                guard let self = self else { return false }
                
                let offsetY = contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                let tableViewHeight = self.tableView.frame.size.height
                
                return offsetY > contentHeight - tableViewHeight - 100
            }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.currentPage += 1
                self.viewModel.loadMovies(page: currentPage)
            })
            .disposed(by: disposeBag)
            self.viewModel.loadMovies(page: currentPage)
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
             viewModel.searchMovies(keyword: searchText, page: 1)
         }
         tableView.reloadData()
     }
}
