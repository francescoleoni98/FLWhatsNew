//
//  File.swift
//  FLWhatsNew
//
//  Created by Francesco Leoni on 08/01/25.
//

import SwiftUI

struct ShowModifier<Icon: View>: ViewModifier {

	@State private var newVersion: WhatsNew?

	var store: WhatsNewStore
	var showSheet: Bool = true
	@ViewBuilder var icon: () -> Icon
	var onClose: (() -> Void)?

	func body(content: Content) -> some View {
		content
			.onAppear {
				if showSheet, let version = store.appropriatePageToPresent() {
					newVersion = version
				}
			}
			.present(item: $newVersion) { version in
				WhatsNewView(version: version, icon: icon, onClose: {
					newVersion = nil
					onClose?()
				})
			}
	}
}

public extension View {

	@ViewBuilder
	func showWhatsNew<Icon: View>(store: WhatsNewStore, showSheet: Bool = true, @ViewBuilder icon: @escaping () -> Icon, onClose: (() -> Void)? = nil) -> some View {
		modifier(ShowModifier(store: store, showSheet: showSheet, icon: icon, onClose: onClose))
	}

#if os(iOS)
	@ViewBuilder
	func fullScreen<Object: Identifiable, Content: View>(item: Binding<Object?>, @ViewBuilder content: @escaping (Object) -> Content) -> some View {
		if #available(iOS 14.0, *) {
			fullScreenCover(item: item, content: content)
		} else {
			sheet(item: item, content: content)
		}
	}
#endif

	@ViewBuilder
	func present<Object: Identifiable, Content: View>(item: Binding<Object?>, @ViewBuilder content: @escaping (Object) -> Content) -> some View {
		#if os(iOS)
		if UIDevice.current.userInterfaceIdiom == .phone {
			fullScreen(item: item, content: content)
		} else {
			sheet(item: item, content: content)
		}
		#else
		sheet(item: item, content: content)
		#endif
	}
}
