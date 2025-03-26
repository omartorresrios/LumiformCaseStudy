//
//  NetworkImageService.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/26/25.
//

import Foundation

protocol ImageService {
	func fetchImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkImageService: ImageService {
	func fetchImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
		if let cachedData = ImageCache.cachedData(forKey: url.absoluteString) {
			completion(.success(cachedData))
			return
		}
		URLSession.shared.dataTask(with: url) { data, _, error in
			if let data = data {
				ImageCache.cacheData(data, forKey: url.absoluteString)
				completion(.success(data))
			} else {
				completion(.failure(error ?? URLError(.badServerResponse)))
			}
		}.resume()
	}
}
