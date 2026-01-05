//
//  RectangularButton.swift
//  FLWhatsNew
//
//  Created by Francesco Leoni on 08/01/25.
//

import SwiftUI

/// A button that takes the entire width space available.
struct RectangularButton: View {
	
	var title: String
	var color: Color = .blue
	var foreground: Color = .white
	var action: () -> Void
	
	var body: some View {
		Button {
			action()
		} label: {
			Text(title)
				.bold()
				.multilineTextAlignment(.center)
				.foregroundColor(foreground)
				.frame(maxWidth: .infinity)
#if os(macOS)
				.frame(height: 44)
#else
				.frame(height: 50)
#endif
				.background(color)
				.hoverEffectIfPresent()
				.clipShape(.rect(cornerRadius: 16, style: .continuous))
		}
		.buttonStyle(.plain)
	}
}
