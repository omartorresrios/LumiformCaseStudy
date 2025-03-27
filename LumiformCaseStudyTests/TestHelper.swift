//
//  TestHelper.swift
//  LumiformCaseStudyTests
//
//  Created by Omar Torres on 3/27/25.
//

import Foundation
@testable import LumiformCaseStudy

enum TestHelper {
	static func mockPage1() -> Page {
		let section = Section(type: "section", title: "Section title", items: [])
		let textQuestion = TextQuestion(type: "text", title: "Text question title")
		let imageQuestion = ImageQuestion(type: "image", title: "Image question title", src: "url")
		let page = Page(type: "page", title: "Main title", items: [GenericItem(section),
																   GenericItem(textQuestion),
																   GenericItem(imageQuestion)])
		return page
	}
	
	static func mockPage2() -> Page {
		let section = Section(type: "section", title: "Section title", items: [])
		let textQuestion = TextQuestion(type: "text", title: "Text question title")
		let imageQuestion = ImageQuestion(type: "image", title: "Image question title", src: "url")
		let page = Page(type: "page", title: "Second page title", items: [GenericItem(section),
																   GenericItem(textQuestion),
																   GenericItem(imageQuestion)])
		return page
	}
}
