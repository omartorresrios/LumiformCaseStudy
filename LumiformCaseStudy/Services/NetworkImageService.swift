//
//  NetworkImageService.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/26/25.
//

import UIKit

protocol ImageService {
	func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class NetworkImageService: ImageService {
	func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
		if let cachedImage = ImageCache.cachedImage(forKey: url.absoluteString) {
			completion(.success(cachedImage))
			return
		}
		URLSession.shared.dataTask(with: url) { data, _, error in
			if let data = data, let image = UIImage(data: data) {
				ImageCache.cacheImage(image, forKey: url.absoluteString)
				completion(.success(image))
			} else {
				completion(.failure(error ?? URLError(.badServerResponse)))
			}
		}.resume()
	}
}
