//
//  ImageCache.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/26/25.
//

import UIKit

final class ImageCache {
	static let shared = NSCache<NSString, NSData>()
	
	static func cacheData(_ image: Data, forKey key: String) {
		shared.setObject(image as NSData, forKey: key as NSString)
	}
	
	static func cachedData(forKey key: String) -> Data? {
		return shared.object(forKey: key as NSString) as Data?
	}
	
	static func resizedImageData(_ imageData: Data, toSize size: CGSize) -> Data? {
		guard let image = UIImage(data: imageData) else { return nil }
		let format = UIGraphicsImageRendererFormat()
		format.opaque = false
		let renderer = UIGraphicsImageRenderer(size: size, format: format)
		let resizedImage = renderer.image { context in
			let rect = CGRect(origin: .zero, size: size)
			image.draw(in: rect, blendMode: .normal, alpha: 1.0)
		}
		return resizedImage.pngData()
	}
}
