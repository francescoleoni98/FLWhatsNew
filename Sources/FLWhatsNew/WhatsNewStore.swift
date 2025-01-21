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

	@MainActor
	public static func configure(_ config: Config) {
		Config.shared = config
	}

	public func pageForCurrentVersion() -> WhatsNew? {
		let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
		return collection.first(where: { $0.version == Version(version) })
	}

	public func appropriatePageToPresent() -> WhatsNew? {
		guard let pageToPresent = pageForCurrentVersion(),
					!UserDefaults.standard.bool(forKey: pageToPresent.version.description) else {
			return nil
		}

		UserDefaults.standard.set(true, forKey: pageToPresent.version.description)

		return pageToPresent
	}
}

public extension WhatsNewStore {

	public struct Config {

		@MainActor internal static var shared: Config = Config()

		public var brandColor: Color
		public var actionTitle: LocalizedStringKey

		public init(brandColor: Color = .blue, actionTitle: LocalizedStringKey = "Continue") {
			self.brandColor = brandColor
			self.actionTitle = actionTitle
		}
	}
}
