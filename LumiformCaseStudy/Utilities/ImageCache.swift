//
//  ImageCache.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/26/25.
//

import UIKit

final class ImageCache {
	static let shared = NSCache<NSString, UIImage>()
	
	static func cacheImage(_ image: UIImage, forKey key: String) {
		shared.setObject(image, forKey: key as NSString)
	}
	
	static func cachedImage(forKey key: String) -> UIImage? {
		return shared.object(forKey: key as NSString)
	}
	
	static func resizedImage(_ image: UIImage, toSize size: CGSize) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: size)
		return renderer.image { _ in
			image.draw(in: CGRect(origin: .zero, size: size))
		}
	}
}
