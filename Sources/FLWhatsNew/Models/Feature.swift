//
//  Feature.swift
//  FLWhatsNew
//
//  Created by Francesco Leoni on 09/01/25.
//

import Foundation

public struct Feature: Identifiable {

	public var id: String
	public var title: String
	public var body: String
	public var image: ImageType

	public enum ImageType {
		case named(String)
		case system(String)
	}

	public init(id: String = UUID().uuidString, title: String, body: String, image: ImageType) {
		self.id = id
		self.title = title
		self.body = body
		self.image = image
	}
}
