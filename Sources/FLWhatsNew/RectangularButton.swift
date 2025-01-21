//
//  RectangularButton.swift
//  FLWhatsNew
//
//  Created by Francesco Leoni on 08/01/25.
//

import SwiftUI

/// A button that takes the entire width space available.
struct RectangularButton: View {

	var title: LocalizedStringKey
	var color: Color = .blue
	var action: () -> Void

	var body: some View {
		Button {
			action()
		} label: {
			Text(title)
				.bold()
				.multilineTextAlignment(.center)
				.foregroundColor(.white)
				.frame(maxWidth: .infinity)
				.frame(height: 50)
				.background(color)
				.hoverEffectIfPresent()
				.clipShape(.rect(cornerRadius: 16, style: .continuous))
		}
	}
}
