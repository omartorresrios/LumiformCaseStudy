//
//  PageViewController.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/23/25.
//

import UIKit

final class PageViewController: UIViewController {
	let viewModel: PageViewModel
	private let tableView = UITableView()
	private let activityIndicator = UIActivityIndicatorView(style: .large)
	private let coordinator: PageCoordinatorProtocol
	private let sectionCell = "SectionCell"
	private let textQuestionCell = "TextQuestionCell"
	private let imageQuestionCell = "ImageQuestionCell"
	
	private let errorLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.textColor = .red
		return label
	}()
	
	init(viewModel: PageViewModel, coordinator: PageCoordinatorProtocol) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupViewModel()
	}
	
	private func setupViewModel() {
		viewModel.stateChanged = { [weak self] state in
			guard let self = self else { return }
			
			switch state {
			case .idle:
				self.activityIndicator.stopAnimating()
				self.errorLabel.isHidden = true
			case .loading:
				self.activityIndicator.startAnimating()
				self.errorLabel.isHidden = true
			case .loaded:
				DispatchQueue.main.async {
					self.activityIndicator.stopAnimating()
					self.errorLabel.isHidden = true
					self.tableView.reloadData()
				}
			}
		}
		viewModel.fetchItems()
	}

	private func setupUI() {
		view.backgroundColor = .white
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.estimatedRowHeight = 100
		tableView.rowHeight = UITableView.automaticDimension
		
		tableView.register(SectionCell.self, forCellReuseIdentifier: sectionCell)
		tableView.register(TextQuestionCell.self, forCellReuseIdentifier: textQuestionCell)
		tableView.register(ImageQuestionCell.self, forCellReuseIdentifier: imageQuestionCell)
		
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(activityIndicator)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(errorLabel)
		errorLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
		])
	}
}

extension PageViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.flattenedItems().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = viewModel.flattenedItems()[indexPath.row]
		
		switch item {
		case let sectionViewModel as SectionViewModel:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: sectionCell,
														   for: indexPath) as? SectionCell else {
				return UITableViewCell()
			}
			cell.configure(with: sectionViewModel)
			return cell
			
		case let textQuestionViewModel as TextQuestionViewModel:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: textQuestionCell,
														   for: indexPath) as? TextQuestionCell else {
				return UITableViewCell()
			}
			cell.configure(with: textQuestionViewModel)
			return cell
			
		case let imageQuestionViewModel as ImageQuestionViewModel:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: imageQuestionCell,
														   for: indexPath) as? ImageQuestionCell else {
				return UITableViewCell()
			}
			cell.configure(with: imageQuestionViewModel)
			cell.delegate = self
			return cell
			
		default:
			return UITableViewCell()
		}
	}
}

extension PageViewController: ImageQuestionCellDelegate {
	func didTapImage(with viewModel: ImageQuestionViewModel) {
		coordinator.showImageDetailsViewController(with: viewModel)
	}
}
