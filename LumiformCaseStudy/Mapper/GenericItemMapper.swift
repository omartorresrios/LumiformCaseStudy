//
//  GenericItemMapper.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/23/25.
//

import Foundation

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
