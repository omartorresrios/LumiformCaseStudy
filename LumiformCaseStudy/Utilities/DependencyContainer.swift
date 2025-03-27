//
//  DependencyContainer.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/27/25.
//

protocol ServiceFactory {
	func createNetworkImageService() -> ImageService
	func createPageControllers(from pages: [Page], coordinator: PageCoordinatorProtocol) -> [PageViewController]
}

final class DependencyFactory: ServiceFactory {
	
	func createNetworkImageService() -> ImageService {
		return NetworkImageService()
	}
	
	func createPageControllers(from pages: [Page], coordinator: PageCoordinatorProtocol) -> [PageViewController] {
		pages.map { PageViewController(viewModel: PageViewModel(page: $0,
																imageService: self.createNetworkImageService()),
									   coordinator: coordinator) }
	}
}
