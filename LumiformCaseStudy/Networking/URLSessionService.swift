//
//  URLSessionService.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/23/25.
//

import Foundation

final class URLSessionService: ServiceProtocol {
	private let urlString: String
		
	init(urlString: String = "https://run.mocky.io/v3/1800b96f-c579-49e5-b0b8-49856a36ce39") {
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
