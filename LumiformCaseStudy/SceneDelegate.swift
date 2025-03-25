//
//  SceneDelegate.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/22/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(frame: windowScene.coordinateSpace.bounds)
		window?.windowScene = windowScene
		let networkService = URLSessionService()
		let itemMapper = GenericItemMapper()
		let repository = GenericItemRepository(networkService: networkService, itemMapper: itemMapper)
		let viewModel = PageViewModel(repository: repository)
		let pageViewController = PageViewController(viewModel: viewModel)
		let navigationController = UINavigationController(rootViewController: pageViewController)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
}
