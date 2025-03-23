//
//  URLSessionService.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/23/25.
//

import Foundation

enum ServiceResult {
	case success(Data, HTTPURLResponse)
	case failure(Error)
}

protocol ServiceProtocol {
	func fetchData(completion: @escaping (ServiceResult) -> Void)
}

final class URLSessionService: ServiceProtocol {
	private let urlString: String
		
	init(urlString: String = "https://run.mocky.io/v3/d403fba7-413f-40d8-bec2-afe6ef4e201e") {
		self.urlString = urlString
	}
	
	func fetchData(completion: @escaping (ServiceResult) -> Void) {
		guard let url = URL(string: urlString) else { return }
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
			} else if let data = data, let response = response as? HTTPURLResponse {
				completion(.success(data, response))
			}
		}.resume()
	}
}

enum FetchDataResult {
	case success(GenericItem)
	case failure(NetworkError)
}

enum NetworkError: Error {
	case invalidData
	case connectivity
	case invalidResponse(statusCode: Int)
}

final class ItemRepository {
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

final class GenericItemMapper {
	
	static func map(_ data: Data, _ response: HTTPURLResponse) -> FetchDataResult {
		guard response.statusCode == 200 else {
			return .failure(NetworkError.invalidResponse(statusCode: response.statusCode))
		}
		
		do {
		   let genericItem = try JSONDecoder().decode(GenericItem.self, from: data)
		   return .success(genericItem)
	   } catch {
		   return .failure(NetworkError.invalidData)
	   }
	}
}
