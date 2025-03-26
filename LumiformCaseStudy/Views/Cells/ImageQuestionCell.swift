//
//  ImageQuestionCell.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

import UIKit

protocol ImageQuestionCellDelegate: AnyObject {
	func didTapImage(with viewModel: ImageQuestionViewModel)
}

final class ImageQuestionCell: UITableViewCell {
	private let titleLabel = UILabel()
	private let questionImageView = UIImageView()
	private let containerView = UIView()
	weak var delegate: ImageQuestionCellDelegate?
	private var viewModel: ImageQuestionViewModel?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		selectionStyle = .none
		
		containerView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
		containerView.layer.cornerRadius = 8
		containerView.layer.borderWidth = 1
		containerView.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
		
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.systemFont(ofSize: 16)
		
		questionImageView.contentMode = .scaleAspectFit
		questionImageView.layer.cornerRadius = 4
		questionImageView.clipsToBounds = true
		questionImageView.isUserInteractionEnabled = true
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
		questionImageView.addGestureRecognizer(tapGesture)
		
		contentView.addSubview(containerView)
		containerView.addSubview(titleLabel)
		containerView.addSubview(questionImageView)
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		questionImageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			
			titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
			titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
			titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
			
			questionImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
			questionImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
			questionImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
			questionImageView.heightAnchor.constraint(equalToConstant: 150),
			questionImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
		])
	}
	
	func configure(with viewModel: ImageQuestionViewModel) {
		self.viewModel = viewModel
		titleLabel.text = viewModel.question.title
		containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
											   constant: 16 + CGFloat(viewModel.nestingLevel * 16)).isActive = true
		
		if let url = URL(string: viewModel.question.src) {
			if let cachedImage = ImageCache.cachedImage(forKey: viewModel.question.src) {
				let resizedImage = ImageCache.resizedImage(cachedImage, 
														   toSize: CGSize(width: 100, height: 100))
				questionImageView.image = resizedImage
				return
			}
			
			let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
				guard let self = self, 
						let data = data, error == nil,
						let image = UIImage(data: data) else {
					print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
					return
				}
				
				ImageCache.cacheImage(image, forKey: viewModel.question.src)
				
				let resizedImage = ImageCache.resizedImage(image, toSize: CGSize(width: 100, height: 100))
				
				DispatchQueue.main.async {
					self.questionImageView.image = resizedImage
				}
			}
			task.resume()
		}
	}
	
	@objc private func imageTapped() {
		if let viewModel = viewModel {
			delegate?.didTapImage(with: viewModel)
		}
	}
}
