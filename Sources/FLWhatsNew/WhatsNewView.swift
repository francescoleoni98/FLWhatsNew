//
//  WhatsNewView.swift
//  BrainDump
//
//  Created by Francesco Leoni on 25/10/24.
//

import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {

	@Published var keyboardShown: Bool = false

	private var cancellables = Set<AnyCancellable>()

	init() {
		#if !os(macOS)
		NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
			.sink { [weak self] _ in
				self?.keyboardShown = true
			}
			.store(in: &cancellables)

		NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
			.sink { [weak self] _ in
				self?.keyboardShown = false
			}
			.store(in: &cancellables)
		#endif
	}
}

public struct WhatsNewView<Icon: View>: View {

	@ObservedObject var keyboard = KeyboardObserver()

	var version: WhatsNew
	var appReviewURL: String?
	@ViewBuilder var icon: () -> Icon
	var onClose: (() -> Void)?

	private let config = WhatsNewStore.Config.shared

	public init(version: WhatsNew, appReviewURL: String? = nil, @ViewBuilder icon: @escaping () -> Icon, onClose: (() -> Void)?) {
		self.version = version
		self.appReviewURL = appReviewURL
		self.icon = icon
		self.onClose = onClose
	}

	public var body: some View {
		VStack(alignment: .center) {
			VStack(alignment: .center) {
				icon()
				#if os(macOS)
					.frame(width: 50, height: 50)
				#else
					.frame(width: 80, height: 80)
				#endif
					.padding(.vertical)

				Text("What's new")
					.foregroundColor(.primary)
			}
#if os(macOS)
			.font(.system(size: 30, weight: .bold))
			#else
			.font(.system(size: 36, weight: .bold))
			#endif

			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading) {
					ForEach(version.features) { feature in
						HStack(spacing: 20) {
							switch feature.image {
							case .named(let name):
								Image(name)
									.resizable()
									.scaledToFit()
									.font(.largeTitle)
									.frame(width: 40, height: 40)
									.foregroundColor(config.brandColor)

							case .system(let name):
								Image(systemName: name)
									.font(.largeTitle)
									.frame(width: 50, height: 40)
									.foregroundColor(config.brandColor)
							}

							VStack(alignment: .leading) {
								Text(feature.title)
									.font(.system(size: 17).bold())
									.fixedSize(horizontal: false, vertical: true)
									.frame(maxWidth: .infinity, alignment: .leading)

								Text(feature.body)
									.font(.system(size: 16))
									.fixedSize(horizontal: false, vertical: true)
									.frame(maxWidth: .infinity, alignment: .leading)
							}
						}
					}
					.padding(.vertical, 7)
				}
			}
			.padding(.horizontal)

			if let appReviewURL, let url = URL(string: appReviewURL) {
				RectangularButton(title: "Rate App", color: config.brandColor, foreground: config.foregroundColor) {
					#if os(macOS)
					NSWorkspace.shared.open(url)
					#else
					UIApplication.shared.open(url)
					#endif

					withAnimation {
						onClose?()
					}
				}

				Button {
					withAnimation {
						onClose?()
					}
				} label: {
					Text("Maybe later")
						.bold()
						.foregroundColor(config.brandColor)
						.frame(height: 44)
				}
#if os(macOS) || os(visionOS)
				.buttonStyle(.plain)
#endif
			} else {
				RectangularButton(title: config.actionTitle, color: config.brandColor, foreground: config.foregroundColor) {
					withAnimation {
						onClose?()
					}
				}
			}
		}
		.padding()
#if os(macOS)
		.frame(width: 400, height: 500)
#else
		.onChange(of: keyboard.keyboardShown) { shown in
			if shown {
				let scenes = UIApplication.shared.connectedScenes
				let windowScene = scenes.first as? UIWindowScene
				windowScene?.windows.first?.endEditing(true)
			}
		}
#endif
	}
}
