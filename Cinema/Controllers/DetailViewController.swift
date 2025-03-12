//
//  DetailViewController.swift
//  Cinema
//
//  Created by Dwistari on 11/03/25.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    var movie: Movie?

    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.isSkeletonable = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rateContainer: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.isSkeletonable = true
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor.orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rateLbl: UILabel = {
        let view = UILabel()
        view.isSkeletonable = true
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
        view.isSkeletonable = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var movieImgView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.gray
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.isSkeletonable = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var movieName: UILabel = {
        let view = UILabel()
        view.text = "Movie name"
        view.numberOfLines = 2
        view.isSkeletonable = true
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var taglineLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.isSkeletonable = true
        view.textColor = UIColor.gray
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var totalRating: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.isSkeletonable = true
        view.textColor = UIColor.black
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var realeselbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.isSkeletonable = true
        view.textColor = UIColor.gray
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var genreLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = UIColor.gray
        view.isSkeletonable = true
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var synopsisLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.text = "Synopsis"
        view.isSkeletonable = true
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var synopsisDesc: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        view.isSkeletonable = true
        view.textColor = UIColor.gray
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var openIMBtn: UIButton = {
        let button = UIButton()
        button.setTitle("OPEN IMDB", for: .normal)
        button.addTarget(self, action: #selector(openBtn), for: .touchUpInside)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.layer.borderWidth = 1
        button.isSkeletonable = true
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    private let viewModel = MovieDetailsViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        loadDetail()
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
            movieImgView.topAnchor.constraint(equalTo: rateContainer.bottomAnchor, constant: -16),
            movieImgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            movieImgView.heightAnchor.constraint(equalToConstant: 150),
            movieImgView.widthAnchor.constraint(equalToConstant: 100),
        ])

        containerView.addSubview(movieName)
        NSLayoutConstraint.activate([
            movieName.topAnchor.constraint(equalTo: rateContainer.bottomAnchor, constant: 16),
            movieName.leadingAnchor.constraint(equalTo: movieImgView.trailingAnchor, constant: 16),
            movieName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        containerView.addSubview(taglineLbl)
        NSLayoutConstraint.activate([
            taglineLbl.topAnchor.constraint(equalTo: movieName.bottomAnchor, constant: 8),
            taglineLbl.leadingAnchor.constraint(equalTo: movieImgView.trailingAnchor, constant: 16),
            taglineLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
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
        
        containerView.addSubview(openIMBtn)
        NSLayoutConstraint.activate([
            openIMBtn.topAnchor.constraint(equalTo: synopsisDesc.bottomAnchor, constant: 12),
            openIMBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            openIMBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
        
    }
    
    private func loadDetail() {
        showLoading()
        viewModel.movies
            .compactMap { $0 }
                .observe(on: MainScheduler.instance)
            .subscribe(onNext: { movies in
                self.hideLoading()
                self.fetchDetailsMovie(detail: movies)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .subscribe(onNext: { error in
                print("Error:", error)
            })
            .disposed(by: disposeBag)

        viewModel.loadDetailsMovie(id: movie?.id ?? 0)

    }
    
    private func fetchDetailsMovie(detail: MovieDetails?) {
        DispatchQueue.main.async {
            guard let data = detail else {return}
                    
            let genreNames = data.genres.map { $0.name }.joined(separator: ", ")
            self.movieName.text = data.originalTitle
            self.taglineLbl.text = data.tagline
            self.realeselbl.text = "Realease time: \(data.releaseDate)"
            self.genreLbl.text = genreNames
            self.synopsisDesc.text = data.overview
            self.rateLbl.text = String(format: "%.1f", data.voteAverage)
            self.coverImgView.sd_setImage(with: URL(string: UrlConstants.urlImage + (data.backdropPath ?? "")), placeholderImage: UIImage(named: "placeholder"))
            self.movieImgView.sd_setImage(with: URL(string: UrlConstants.urlImage + (data.posterPath ?? "")), placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    private func showLoading() {
        DispatchQueue.main.async {
            self.coverImgView.showAnimatedSkeleton()
            self.movieImgView.showAnimatedSkeleton()
            self.movieName.showAnimatedSkeleton()
            self.synopsisDesc.showAnimatedSkeleton()
            self.taglineLbl.showAnimatedSkeleton()
            self.openIMBtn.showAnimatedSkeleton()
            self.rateContainer.showAnimatedSkeleton()
            self.realeselbl.showAnimatedSkeleton()
            self.genreLbl.showAnimatedSkeleton()
        }
    }
    
    private func hideLoading() {
        DispatchQueue.main.async {
            self.coverImgView.hideSkeleton()
            self.movieImgView.hideSkeleton()
            self.movieName.hideSkeleton()
            self.synopsisDesc.hideSkeleton()
            self.taglineLbl.hideSkeleton()
            self.openIMBtn.hideSkeleton()
            self.rateContainer.hideSkeleton()
            self.realeselbl.hideSkeleton()
            self.genreLbl.hideSkeleton()
                        
            self.coverImgView.isSkeletonable = false
            self.movieImgView.isSkeletonable = false
            self.movieName.isSkeletonable = false
            self.synopsisDesc.isSkeletonable = false
            self.taglineLbl.isSkeletonable = false
            self.openIMBtn.isSkeletonable = false
            self.rateContainer.isSkeletonable = false
            self.realeselbl.isSkeletonable = false
            self.genreLbl.isSkeletonable = false
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func openBtn() {
        if let url = URL(string: "https://www.imdb.com/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
        
}
