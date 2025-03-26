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
		
		questionImageView.contentMode = .scaleAspectFit
		questionImageView.layer.cornerRadius = 4
		questionImageView.clipsToBounds = true
		questionImageView.isUserInteractionEnabled = true
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
		questionImageView.addGestureRecognizer(tapGesture)
		
		contentView.addSubview(containerView)
		containerView.addSubview(questionImageView)
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		questionImageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			
			questionImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
			questionImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
			questionImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
			questionImageView.heightAnchor.constraint(equalToConstant: 150),
			questionImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
		])
	}
	
	func configure(with viewModel: ImageQuestionViewModel) {
		self.viewModel = viewModel
		containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
											   constant: 16 + CGFloat(viewModel.nestingLevel * 16)).isActive = true
		
		viewModel.onImageLoaded = { [weak self] data in
			let smallImage = UIImage(data: data)
			self?.questionImageView.image = smallImage
		}
		viewModel.loadImage(fullSize: false)
	}
	
	@objc private func imageTapped() {
		if let viewModel = viewModel {
			delegate?.didTapImage(with: viewModel)
		}
	}
}
