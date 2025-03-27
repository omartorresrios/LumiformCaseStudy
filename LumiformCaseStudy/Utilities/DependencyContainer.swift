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
}
