//
//  SectionCell.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/24/25.
//

import UIKit

final class SectionCell: UITableViewCell {
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
		
		containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		containerView.layer.cornerRadius = 8
		
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		
		contentView.addSubview(containerView)
		containerView.addSubview(titleLabel)
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			
			titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
			titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
			titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
			titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
		])
	}
	
	func configure(with viewModel: SectionViewModel) {
		titleLabel.text = viewModel.title
		
		let baseFontSize: CGFloat = 18
		let fontSize = max(baseFontSize - CGFloat(viewModel.nestingLevel * 2), 14)
		titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
		
		containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
											   constant: 16 + CGFloat(viewModel.nestingLevel * 16)).isActive = true
	}
}
