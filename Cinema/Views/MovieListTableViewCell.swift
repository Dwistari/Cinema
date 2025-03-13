//
//  MovieListTableViewCell.swift
//  Cinema
//
//  Created by Dwistari on 11/03/25.
//

import UIKit
import SkeletonView
import SDWebImage

class MovieListTableViewCell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.isSkeletonable = true
        view.layer.borderColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    lazy var movieImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.lightGray
        view.tintColor = .gray
        view.layer.masksToBounds = true
        view.isSkeletonable = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.isSkeletonable = true
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var movieName: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = UIColor.black
        view.isSkeletonable = true
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        stackView.isSkeletonable = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var totalRating: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = UIColor.orange
        view.isSkeletonable = true
        view.font = UIFont.systemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var descLbl: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = UIColor.black
        view.isSkeletonable = true
        view.font = UIFont.systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSkeleton()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeleton()
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        containerView.addSubview(movieImgView)
        NSLayoutConstraint.activate([
            movieImgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            movieImgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            movieImgView.heightAnchor.constraint(equalToConstant: 120),
            movieImgView.widthAnchor.constraint(equalToConstant: 100),
            movieImgView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10)
        ])
        
        containerView.addSubview(contentContainer)
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            contentContainer.leadingAnchor.constraint(equalTo: movieImgView.trailingAnchor, constant: 8),
            contentContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            contentContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
        ])

        contentContainer.addSubview(movieName)
        NSLayoutConstraint.activate([
            movieName.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 12),
            movieName.leadingAnchor.constraint(equalTo: movieImgView.trailingAnchor, constant: 12),
            movieName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
        
        contentContainer.addSubview(ratingStackView)
        NSLayoutConstraint.activate([
            ratingStackView.topAnchor.constraint(equalTo: movieName.bottomAnchor, constant: 12),
            ratingStackView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 12),
            ratingStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentContainer.trailingAnchor, constant: -12),
            ratingStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        contentContainer.addSubview(totalRating)
        NSLayoutConstraint.activate([
            totalRating.topAnchor.constraint(equalTo: movieName.bottomAnchor, constant: 12),
            totalRating.leadingAnchor.constraint(equalTo: ratingStackView.trailingAnchor, constant: 12),
            totalRating.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
        ])
        
        contentContainer.addSubview(descLbl)
        NSLayoutConstraint.activate([
            descLbl.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 12),
            descLbl.leadingAnchor.constraint(equalTo: movieImgView.trailingAnchor, constant: 12),
            descLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentContainer.layer.shadowPath = UIBezierPath(roundedRect: contentContainer.bounds, cornerRadius: 8).cgPath
    }
    

    private func setupSkeleton() {
        isSkeletonable = true
        containerView.isSkeletonable = true
        movieImgView.isSkeletonable = true
        movieName.isSkeletonable = true
    }
    
    private func setupRatingView(rating: Double) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
       
        let fullStars = Int(rating/2)
        let hasHalfStar = (rating - Double(fullStars)) >= 0.5
        
        for _ in 0..<fullStars {
              let starImageView = UIImageView()
              starImageView.contentMode = .scaleAspectFit
              starImageView.tintColor = .systemYellow
              starImageView.image = UIImage(systemName: "star.fill")
              ratingStackView.addArrangedSubview(starImageView)
          }
        
        if hasHalfStar {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = .systemYellow
            starImageView.image = UIImage(systemName: "star.leadinghalf.filled")
            ratingStackView.addArrangedSubview(starImageView)
        }
        
        let totalStars = 5
        let remainingStars = totalStars - fullStars - (hasHalfStar ? 1 : 0)
        let safeRemainingStars = max(0, remainingStars)
        for _ in 0..<safeRemainingStars {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = .lightGray
            starImageView.image = UIImage(systemName: "star")
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
    
    func bindData(data: Movie?) {
        guard let movie = data else {return}
        movieName.text = movie.originalTitle
        descLbl.text = movie.overview
        totalRating.text = String(format: "%.1f", data?.voteAverage ?? 0)
        setupRatingView(rating: movie.voteAverage)
        movieImgView.sd_setImage(with: URL(string: UrlConstants.urlImage + (movie.posterPath ?? "")), placeholderImage: UIImage(systemName: "photo"))
    }
}
