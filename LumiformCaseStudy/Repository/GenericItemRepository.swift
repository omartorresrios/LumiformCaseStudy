//
//  GenericItemRepository.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/23/25.
//

import Foundation

enum FetchDataResult {
	case success(GenericItem)
	case failure(NetworkError)
}

enum FetchPagesResult {
	case success([Page])
	case failure(NetworkError)
}

enum NetworkError: Error {
	case invalidData
	case connectivity
	case invalidResponse(statusCode: Int)
}

protocol GenericItemRepositoryProtocol {
	func fetchItem(completion: @escaping (FetchDataResult) -> Void)
	func fetchTopLevelPages(completion: @escaping (FetchPagesResult) -> Void)
}

final class GenericItemRepository: GenericItemRepositoryProtocol {
	private let networkService: ServiceProtocol
	private let itemMapper: GenericItemMapper
	
	init(networkService: ServiceProtocol, itemMapper: GenericItemMapper) {
		self.networkService = networkService
		self.itemMapper = itemMapper
	}
	
	func fetchItem(completion: @escaping (FetchDataResult) -> Void) {
		networkService.fetchData { result in
			switch result {
			case let .success(data, response):
				completion(GenericItemMapper.map(data, response))
			case .failure(let error):
				completion(.failure(.connectivity))
			}
		}
	}
	
	func fetchTopLevelPages(completion: @escaping (FetchPagesResult) -> Void) {
		networkService.fetchData { [weak self] result in
			guard let self = self else { return }
			switch result {
			case let .success(data, response):
				let fetchResult = GenericItemMapper.map(data, response)
				switch fetchResult {
				case .success(let item):
					if let rootPage = item.asPage {
						let topLevelPages = self.extractTopLevelPages(from: rootPage)
						completion(.success(topLevelPages))
					} else {
						completion(.failure(.invalidData))
					}
				case .failure(let error):
					completion(.failure(error))
				}
			case .failure:
				completion(.failure(.connectivity))
			}
		}
	}
	
	private func extractTopLevelPages(from page: Page) -> [Page] {
		var topLevelPages: [Page] = [page]
		for item in page.items {
			if let nestedPage = item.asPage {
				topLevelPages.append(nestedPage)
			}
		}
		return topLevelPages
	}
}
