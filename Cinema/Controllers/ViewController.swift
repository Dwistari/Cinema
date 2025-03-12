//
//  ViewController.swift
//  Cinema
//
//  Created by Dwistari on 11/03/25.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class ViewController: UIViewController {
    
    var movies: [Movie]?
    var currentPage = 1
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.tintColor = UIColor.gray
        searchBar.backgroundImage = UIImage()
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "Search"
        searchBar.searchTextField.tintColor = UIColor.gray
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(MovieListTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        view.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.isSkeletonable = true
        view.showSkeleton()
        view.refreshControl = refreshControl
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        return control
    }()
    
    lazy var dataNotFoundLbl: UILabel = {
        let view = UILabel()
        view.text = "Data Not Found"
        view.isHidden = true
        view.textColor = UIColor.gray
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let viewModel = MovieListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie"
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black ]
        setupView()
        loadMoviesList()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupView() {
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
        
        view.addSubview(dataNotFoundLbl)
        NSLayoutConstraint.activate([
            dataNotFoundLbl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            dataNotFoundLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dataNotFoundLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
    private func loadMoviesList() {
        showLoading()
        viewModel.movies
            .subscribe(onNext: { movies in
                self.movies = movies
                self.hideLoading()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.dataNotFoundLbl.isHidden = !movies.isEmpty
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .subscribe(onNext: { error in
                print("Error:", error)
                print("loadMoviesList-error")
                
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
    
    
    @objc func onPullToRefresh(_ sender: Any) {
        self.viewModel.refreshMovies()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.movies.value.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieListTableViewCell
            cell.bindData(data: movies?[indexPath.row])
            return cell
        } else {
            print("loading showsssss")
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            cell.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.movie = movies?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func showLoading() {
        DispatchQueue.main.async {
            self.tableView.showAnimatedSkeleton()
        }
    }
    
    private func hideLoading() {
        DispatchQueue.main.async {
            self.tableView.stopSkeletonAnimation()
            self.tableView.hideSkeleton(reloadDataAfter: true)
        }
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

extension ViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MovieCell"
    }
}
