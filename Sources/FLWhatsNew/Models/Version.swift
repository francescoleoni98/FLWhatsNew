//
//  Version.swift
//  FLWhatsNew
//
//  Created by Francesco Leoni on 09/01/25.
//

import Foundation

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
