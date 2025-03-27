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
	
	private let loadingIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .medium)
		indicator.color = .gray
		indicator.hidesWhenStopped = true
		return indicator
	}()
	
	private let errorLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.textColor = .red
		return label
	}()
	
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
		containerView.addSubview(loadingIndicator)
		containerView.addSubview(errorLabel)
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		questionImageView.translatesAutoresizingMaskIntoConstraints = false
		loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
		errorLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			
			questionImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
			questionImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
			questionImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
			questionImageView.heightAnchor.constraint(equalToConstant: 150),
			questionImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
			
			loadingIndicator.centerXAnchor.constraint(equalTo: questionImageView.centerXAnchor),
			loadingIndicator.centerYAnchor.constraint(equalTo: questionImageView.centerYAnchor),
			
			errorLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			errorLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			errorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
			errorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
		])
	}
	
	func configure(with viewModel: ImageQuestionViewModel) {
		self.viewModel = viewModel
		containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
											  constant: 16 + CGFloat(viewModel.nestingLevel * 16)).isActive = true
		
		viewModel.onStateChanged = { [weak self] state in
			guard let self = self else { return }
			switch state {
			case .idle:
				self.loadingIndicator.stopAnimating()
				self.questionImageView.image = nil
				
			case .loading:
				self.loadingIndicator.startAnimating()
				self.questionImageView.image = nil
				
			case .loaded:
				self.loadingIndicator.stopAnimating()
				
			case .error(let error):
				self.loadingIndicator.stopAnimating()
				self.questionImageView.image = nil
				errorLabel.text = error.localizedDescription
			}
		}
		
		viewModel.onImageLoaded = { [weak self] data in
			let smallImage = UIImage(data: data)
			DispatchQueue.main.async {
				self?.questionImageView.image = smallImage
			}
		}
		viewModel.loadImage(fullSize: false)
	}
	
	@objc private func imageTapped() {
		if let viewModel = viewModel {
			delegate?.didTapImage(with: viewModel)
		}
	}
}
