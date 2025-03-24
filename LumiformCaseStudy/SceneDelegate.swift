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
		let genericItem = GenericItem(Section(type: "section", 
											  title: "Test Section",
											  items: [GenericItem(TextQuestion(type: "text",
																			   title: "Test text question"))]))
		let pageViewController = PageViewController(viewModel: PageViewModel(page: Page(type: "page",
																						title: "Test Page",
																						items: [genericItem])))
		let navigationController = UINavigationController(rootViewController: pageViewController)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
}
