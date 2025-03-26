//
//  PageCoordinator.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/26/25.
//

import UIKit

protocol PageCoordinatorProtocol {
	func didSwitchToPage(_ viewController: PageViewController)
	func showImageDetailsViewController(with viewModel: ImageQuestionViewModel)
}

final class PageCoordinator: PageCoordinatorProtocol {
	private let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func didSwitchToPage(_ viewController: PageViewController) {
		viewController.viewModel.fetchItems()
	}
	
	func showImageDetailsViewController(with viewModel: ImageQuestionViewModel) {
		let detailVC = ImageDetailViewController(viewModel: viewModel)
		navigationController.pushViewController(detailVC, animated: true)
	}
}
