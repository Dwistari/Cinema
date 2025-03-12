//
//  DetailViewController.swift
//  Cinema
//
//  Created by Dwistari on 11/03/25.
//

import UIKit


class DetailViewController: UIViewController {
    
    var movie: Movie?

    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rateContainer: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor.orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rateLbl: UILabel = {
        let view = UILabel()
        view.text = "8/10"
        view.textColor = UIColor.white
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var coverImgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.gray
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var movieImgView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.red
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var movieName: UILabel = {
        let view = UILabel()
        view.text = "Movie name"
        view.numberOfLines = 2
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var taglineLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = UIColor.gray
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var totalRating: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = UIColor.black
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var realeselbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = UIColor.gray
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var genreLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = UIColor.gray
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var synopsisLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.text = "Synopsis"
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var synopsisDesc: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "SynopsisSynopsisSynopsisSynopsisSynopsisSynopsisSynopsisSynopsisSynopsisSynopsisSynopsisSynopsis"
        view.textColor = UIColor.gray
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var viewModel: MovieDetailsViewModel = {
        let viewModel = MovieDetailsViewModel()
        viewModel.getDetailsMovie = fetchDetailsMovie
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        viewModel.loadDetailsMovie(id: movie?.id ?? 0)
    }
    
    
    private func setupView() {
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        containerView.addSubview(coverImgView)
        NSLayoutConstraint.activate([
            coverImgView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImgView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        containerView.addSubview(rateContainer)
        NSLayoutConstraint.activate([
            rateContainer.topAnchor.constraint(equalTo: coverImgView.bottomAnchor, constant: -16),
            rateContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            rateContainer.heightAnchor.constraint(equalToConstant: 50),
            rateContainer.widthAnchor.constraint(equalToConstant: 50)

        ])
        
        rateContainer.addSubview(rateLbl)
        NSLayoutConstraint.activate([
            rateLbl.centerXAnchor.constraint(equalTo: rateContainer.centerXAnchor),
            rateLbl.centerYAnchor.constraint(equalTo: rateContainer.centerYAnchor),
        ])
        
        containerView.addSubview(movieImgView)
        NSLayoutConstraint.activate([
            movieImgView.topAnchor.constraint(equalTo: coverImgView.bottomAnchor, constant: -16),
            movieImgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            movieImgView.heightAnchor.constraint(equalToConstant: 150),
            movieImgView.widthAnchor.constraint(equalToConstant: 100),
            
        ])

        containerView.addSubview(movieName)
        NSLayoutConstraint.activate([
            movieName.topAnchor.constraint(equalTo: coverImgView.bottomAnchor, constant: 16),
            movieName.leadingAnchor.constraint(equalTo: movieImgView.trailingAnchor, constant: 16),
            movieName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        containerView.addSubview(taglineLbl)
        NSLayoutConstraint.activate([
            taglineLbl.topAnchor.constraint(equalTo: movieName.bottomAnchor, constant: 8),
            taglineLbl.leadingAnchor.constraint(equalTo: movieImgView.trailingAnchor, constant: 16),
            taglineLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
        ])

        
        containerView.addSubview(realeselbl)
        NSLayoutConstraint.activate([
            realeselbl.topAnchor.constraint(equalTo: taglineLbl.bottomAnchor, constant: 16),
            realeselbl.leadingAnchor.constraint(equalTo: movieImgView.trailingAnchor, constant: 16),
            realeselbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
        ])

        containerView.addSubview(genreLbl)
        NSLayoutConstraint.activate([
            genreLbl.topAnchor.constraint(equalTo: realeselbl.bottomAnchor, constant: 8),
            genreLbl.leadingAnchor.constraint(equalTo: movieImgView.trailingAnchor, constant: 16),
            genreLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
        ])
        
        containerView.addSubview(synopsisLbl)
        NSLayoutConstraint.activate([
            synopsisLbl.topAnchor.constraint(equalTo: movieImgView.bottomAnchor, constant: 16),
            synopsisLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            synopsisLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        containerView.addSubview(synopsisDesc)
        NSLayoutConstraint.activate([
            synopsisDesc.topAnchor.constraint(equalTo: synopsisLbl.bottomAnchor, constant: 12),
            synopsisDesc.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            synopsisDesc.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
        
    }
    
    private func fetchDetailsMovie() {
        DispatchQueue.main.async {
            guard let data = self.viewModel.movies else {return}
            let genreNames = data.genres.map { $0.name }.joined(separator: ", ")
            
            self.movieName.text = data.originalTitle
            self.taglineLbl.text = data.tagline
            self.realeselbl.text = "Realease time: \(data.releaseDate)"
            self.genreLbl.text = genreNames
            self.synopsisDesc.text = data.overview
            self.rateLbl.text = String(format: "%.1f", data.voteAverage)
            self.coverImgView.loadImage(from: UrlConstants.urlImage + (data.backdropPath ?? ""))
            self.movieImgView.loadImage(from: UrlConstants.urlImage + (data.posterPath ?? ""))

        }
    }
        
}
