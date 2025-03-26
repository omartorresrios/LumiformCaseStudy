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
	
	private let errorLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.textColor = .red
		return label
	}()
	
	init(viewModel: PageViewModel) {
		self.viewModel = viewModel
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
			case .error(let error):
				self.activityIndicator.stopAnimating()
				self.errorLabel.isHidden = false
				self.errorLabel.text = "Error: \(error.localizedDescription)"
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
		
		tableView.register(SectionCell.self, forCellReuseIdentifier: "SectionCell")
		tableView.register(TextQuestionCell.self, forCellReuseIdentifier: "TextQuestionCell")
		tableView.register(ImageQuestionCell.self, forCellReuseIdentifier: "ImageQuestionCell")
		
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
	
	private func flattenedItems() -> [GenericItemViewModel] {
		var result: [GenericItemViewModel] = []
		
		for item in viewModel.items {
			result.append(item)
			
			if let sectionViewModel = item as? SectionViewModel {
				result.append(contentsOf: flattenItems(for: sectionViewModel))
			}
		}
		
		return result
	}
	
	private func flattenItems(for sectionViewModel: SectionViewModel) -> [GenericItemViewModel] {
		var result: [GenericItemViewModel] = []
		
		for item in sectionViewModel.items {
			result.append(item)
			
			if let nestedSection = item as? SectionViewModel {
				result.append(contentsOf: flattenItems(for: nestedSection))
			}
		}
		
		return result
	}
}

extension PageViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return flattenedItems().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = flattenedItems()[indexPath.row]
		
		switch item {
		case let pageViewModel as PageViewModel:
			let cell = UITableViewCell(style: .default, reuseIdentifier: "PageCell")
			cell.textLabel?.text = pageViewModel.title
			cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
			cell.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
			return cell
			
		case let sectionViewModel as SectionViewModel:
			let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
			cell.configure(with: sectionViewModel)
			return cell
			
		case let textQuestionViewModel as TextQuestionViewModel:
			let cell = tableView.dequeueReusableCell(withIdentifier: "TextQuestionCell", for: indexPath) as! TextQuestionCell
			cell.configure(with: textQuestionViewModel)
			return cell
			
		case let imageQuestionViewModel as ImageQuestionViewModel:
			let cell = tableView.dequeueReusableCell(withIdentifier: "ImageQuestionCell", for: indexPath) as! ImageQuestionCell
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
		let detailVC = ImageDetailViewController(viewModel: viewModel)
		navigationController?.pushViewController(detailVC, animated: true)
	}
}
