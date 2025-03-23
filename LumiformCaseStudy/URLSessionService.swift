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
