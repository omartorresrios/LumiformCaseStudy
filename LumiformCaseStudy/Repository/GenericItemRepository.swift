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

enum NetworkError: Error {
	case invalidData
	case connectivity
	case invalidResponse(statusCode: Int)
}

protocol GenericItemRepositoryProtocol {
	func fetchItem(completion: @escaping (FetchDataResult) -> Void)
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
}
