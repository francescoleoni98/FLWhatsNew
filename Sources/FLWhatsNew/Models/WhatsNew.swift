//
//  WhatsNew.swift
//  FLWhatsNew
//
//  Created by Francesco Leoni on 09/01/25.
//

import Foundation

public struct WhatsNew: Identifiable {

	public var id: String { version.description }
	public var version: Version
	public var features: [Feature]

	public init(version: Version, features: [Feature], bundle: Bundle = .main) {
		self.version = version
		self.features = features
	}
}
