//
//  Models.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/22/25.
//

protocol Item: Decodable {
	var type: String { get }
}

struct Page: Item {
	let type: String
	let title: String
	let items: [GenericItem]
}

struct Section: Item {
	let type: String
	let title: String
	let items: [GenericItem]
}

protocol Question: Item {
	var title: String { get }
}

struct TextQuestion: Question {
	let type: String
	let title: String
}

struct ImageQuestion: Question {
	let type: String
	let title: String
	let src: String
}

struct GenericItem: Decodable {
	private let _item: Item
	
	var asPage: Page? { return _item as? Page }
	var asSection: Section? { return _item as? Section }
	var asTextQuestion: TextQuestion? { return _item as? TextQuestion }
	var asImageQuestion: ImageQuestion? { return _item as? ImageQuestion }
	
	func get<T: Item>() -> T? {
		return _item as? T
	}
	
	init(_ item: Item) {
		self._item = item
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .type)
		
		switch type {
		case "page":
			self._item = try Page(from: decoder)
		case "section":
			self._item = try Section(from: decoder)
		case "text":
			self._item = try TextQuestion(from: decoder)
		case "image":
			self._item = try ImageQuestion(from: decoder)
		default:
			throw DecodingError.dataCorruptedError(forKey: .type, in: container,
												   debugDescription: "Unknown type \(type)")
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case type
	}
}
