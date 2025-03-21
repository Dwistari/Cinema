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
import Toast

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
    
        
    lazy var viewModel: MovieListViewModel = {
        let viewModel = MovieListViewModel(apiService: APIService())
        return viewModel
    }()
    
    // Clean obeject when object clean from memory
    deinit {
        print("MovieListViewController deallocated")
    }
    
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
            .observe(on: MainScheduler.instance) // Memastikan eksekusi di main thread
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else { return }
                self.movies = movies
                self.fetchDataList()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.view.makeToast(error, duration: 3.0, position: .bottom)
            })
            .disposed(by: disposeBag)
        self.viewModel.loadMovies()
    }
    
    private func fetchDataList() {
        if let data = movies {
            self.dataNotFoundLbl.isHidden = !data.isEmpty
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.hideLoading()
            }
        }
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
        return viewModel.movies.value.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moviesCount = viewModel.movies.value.count

        if indexPath.row == moviesCount - 1 {
            self.viewModel.loadMoreMovies()
        }
        
        // Menampilkan sel movie
        if indexPath.row < moviesCount {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieListTableViewCell else {
                return UITableViewCell()
            }
            cell.bindData(data: movies?[indexPath.row])
            return cell
        }
        
        // Menampilkan loading indicator
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else {
            return UITableViewCell()
        }
        cell.startAnimating()
        return cell
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
            self.tableView.showSkeleton()

        }
    }
    
    private func hideLoading() {
        self.tableView.stopSkeletonAnimation()
        self.tableView.hideSkeleton(reloadDataAfter: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text ?? ""
        if !keyword.isEmpty {
            viewModel.searchMovies(keyword: keyword, page: 1)
        } else {
            viewModel.loadMovies() // Load move from Core Data /API
        }
        tableView.reloadData()
        
        searchBar.resignFirstResponder()
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
