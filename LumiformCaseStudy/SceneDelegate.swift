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
		let pageViewController = PageViewController()
		let navigationController = UINavigationController(rootViewController: pageViewController)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
}
