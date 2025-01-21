//
//  Extensions.swift
//  FLWhatsNew
//
//  Created by Francesco Leoni on 08/01/25.
//

import SwiftUI

extension View {
	
	@ViewBuilder
	func hoverEffectIfPresent() -> some View {
#if os(iOS) || os(visionOS)
		if #available(iOS 18.0, visionOS 1.0, *) {
			hoverEffect()
		} else {
			self
		}
#else
		self
#endif
	}
}
