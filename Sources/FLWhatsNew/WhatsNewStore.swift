//
//  WhatsNew.swift
//  BrainDump
//
//  Created by Francesco Leoni on 25/10/24.
//

import SwiftUI

public class WhatsNewStore {

	@MainActor
	static public var isTesting: Bool = false

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

	@MainActor
	public func appropriatePageToPresent() -> WhatsNew? {
		guard !WhatsNewStore.isTesting else {
			return pageForCurrentVersion()
		}

		guard let pageToPresent = pageForCurrentVersion(),
					!UserDefaults.standard.bool(forKey: pageToPresent.version.description) else {
			return nil
		}

		UserDefaults.standard.set(true, forKey: pageToPresent.version.description)

		return pageToPresent
	}
}

public extension WhatsNewStore {

	struct Config {

		@MainActor internal static var shared: Config = Config(appName: "Brain Dump", brandColor: .black, foregroundColor: .white, actionTitle: "Test")

		public var appName: String?
		public var brandColor: Color
		public var foregroundColor: Color
		public var actionTitle: LocalizedStringKey

		public init(appName: String? = nil, brandColor: Color = .blue, foregroundColor: Color = .white, actionTitle: LocalizedStringKey = "Continue") {
			self.appName = appName
			self.brandColor = brandColor
			self.foregroundColor = foregroundColor
			self.actionTitle = actionTitle
		}
	}
}
