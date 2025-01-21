//
//  WhatsNew.swift
//  BrainDump
//
//  Created by Francesco Leoni on 25/10/24.
//

import SwiftUI

public class WhatsNewStore {

	var collection: [WhatsNew]

	public init(collection: [WhatsNew]) {
		self.collection = collection
	}

	public func pageForCurrentVersion() -> WhatsNew? {
		let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
		return collection.first(where: { $0.version == Version(version) })
	}

	public func appropriatePageToPresent() -> WhatsNew? {
		guard let pageToPresent = pageForCurrentVersion(),
					Defaults.get(Bool.self, forKey: pageToPresent.version.description) == nil else {
			return nil
		}

		Defaults.store(true, forKey: pageToPresent.version.description)

		return pageToPresent
	}
}

public struct Feature: Identifiable {

	public var id: String = UUID().uuidString
	public var title: String
	public var body: String
	public var image: ImageType

	public enum ImageType {
		case named(String)
		case system(String)
	}
}

public struct WhatsNew {

	public var version: Version
	public var features: [Feature]
//	public var action: Action

//	public struct Action {
//
//		public var title: String
//		public var color: Color
//
//		public init(title: String, color: Color, bundle: Bundle = .main) {
//			self.title = title
//			self.color = color
//		}
//	}

	public init(version: Version, features: [Feature], bundle: Bundle = .main) {
		self.version = version
		self.features = features
//		self.action = action
	}
}

public struct Version: Comparable, ExpressibleByStringLiteral, CustomStringConvertible {

	var major: Int
	var minor: Int
	var patch: Int

	public init(_ version: String?) {
		let strings = version?.components(separatedBy: ".") ?? ["0", "0", "0"]
		let components = strings.compactMap(Int.init)

		self.major = components.indices.contains(0) ? components[0] : 0
		self.minor = components.indices.contains(1) ? components[1] : 0
		self.patch = components.indices.contains(2) ? components[2] : 0
	}

	public init(iOS: String? = nil, macOS: String? = nil, visionOS: String? = nil) {
		#if os(iOS)
		self.init(iOS)
		#elseif os(macOS)
		self.init(macOS)
		#elseif os(visionOS)
		self.init(visionOS)
		#else
		self.init(iOS)
		#endif
	}

	public init(major: Int, minor: Int, patch: Int) {
		self.major = major
		self.minor = minor
		self.patch = patch
	}

	public init(stringLiteral value: String) {
		self.init(value)
	}

	public var description: String {
		[major, minor, patch].map(String.init).joined(separator: ".")
	}

	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.description.compare(rhs.description, options: .numeric) == .orderedAscending
	}
}
