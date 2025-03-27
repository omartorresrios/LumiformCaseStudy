//
//  DependencyContainer.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/27/25.
//

final class DependencyContainer {
	static let shared = DependencyContainer()
	
	private init() {}
	
	lazy var networkImageService: NetworkImageService = {
		return NetworkImageService()
	}()
	
	func createPageControllers(from pages: [Page], coordinator: PageCoordinatorProtocol) -> [PageViewController] {
		pages.map { PageViewController(viewModel: PageViewModel(page: $0), coordinator: coordinator) }
	}
}
