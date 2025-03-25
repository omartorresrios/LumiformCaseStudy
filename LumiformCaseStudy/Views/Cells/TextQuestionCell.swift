//
//  TextQuestionCell.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

import UIKit

final class TextQuestionCell: UITableViewCell {
	private let titleLabel = UILabel()
	private let containerView = UIView()
	
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
		
		contentView.addSubview(containerView)
		containerView.addSubview(titleLabel)
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
			
			titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
			titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
			titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
			titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
		])
	}
	
	func configure(with viewModel: TextQuestionViewModel) {
		titleLabel.text = viewModel.question.title
	}
}
