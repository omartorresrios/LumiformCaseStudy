//
//  PageViewController.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/23/25.
//

import Foundation
import UIKit

protocol GenericItemViewModel {
	var type: String { get }
}

final class PageViewModel: GenericItemViewModel {
	let page: Page
	var items: [GenericItemViewModel] = []
	var type: String { return "page" }
	
	init(page: Page) {
		self.page = page
		setupItems()
	}
	
	private func setupItems() {
		for item in page.items {
			if let nestedPage = item.asPage {
				let nestedPageViewModel = PageViewModel(page: nestedPage)
				items.append(nestedPageViewModel)
			} else if let section = item.asSection {
				items.append(SectionViewModel(section: section, nestingLevel: 0))
			} else if let textQuestion = item.asTextQuestion {
				items.append(TextQuestionViewModel(question: textQuestion))
			} else if let imageQuestion = item.asImageQuestion {
				items.append(ImageQuestionViewModel(question: imageQuestion))
			}
		}
	}
}

final class SectionViewModel: GenericItemViewModel {
	let section: Section
	let nestingLevel: Int
	var type: String { return "section" }
	var items: [GenericItemViewModel] = []
	
	init(section: Section, nestingLevel: Int) {
		self.section = section
		self.nestingLevel = nestingLevel
		setupItems()
	}
	
	private func setupItems() {
		for item in section.items {
			if let section = item.asSection {
				items.append(SectionViewModel(section: section, nestingLevel: nestingLevel + 1))
			} else if let textQuestion = item.asTextQuestion {
				items.append(TextQuestionViewModel(question: textQuestion))
			} else if let imageQuestion = item.asImageQuestion {
				items.append(ImageQuestionViewModel(question: imageQuestion))
			}
		}
	}
}

final class TextQuestionViewModel: GenericItemViewModel {
	let question: TextQuestion
	var type: String { return "text" }
	
	init(question: TextQuestion) {
		self.question = question
	}
}

final class ImageQuestionViewModel: GenericItemViewModel {
	let question: ImageQuestion
	var type: String { return "image" }
	
	init(question: ImageQuestion) {
		self.question = question
	}
}

final class PageViewController: UIViewController {
	private let tableView = UITableView()
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		title = "Main Page"
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
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

extension PageViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
		return cell
	}
}
