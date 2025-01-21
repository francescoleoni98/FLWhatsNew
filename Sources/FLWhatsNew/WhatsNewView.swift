//
//  WhatsNewView.swift
//  BrainDump
//
//  Created by Francesco Leoni on 25/10/24.
//

import SwiftUI

struct WhatsNewView: View {

	@EnvironmentObject var state: AppState

	var version: WhatsNew

	var body: some View {
		VStack(alignment: .center) {
			VStack(alignment: .center) {
				Image("pen")
					.resizable()
					.scaledToFit()
					.frame(width: 50, height: 50)
					.foregroundStyle(Color("white"))
					.padding(24)
					.background(Color("black").gradient, in: .rect(cornerRadius: 28))
					.padding(.bottom)

				Text("What's new")
					.foregroundColor(.primary)
			}
			.font(.system(size: 36, weight: .bold))

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
									.foregroundColor(.accentColor)

							case .system(let name):
								Image(systemName: name)
									.font(.largeTitle)
									.frame(width: 50, height: 40)
									.foregroundColor(.accentColor)
							}

							VStack(alignment: .leading) {
								Text(feature.title)
									.font(.system(size: 17).bold())

								Text(feature.body)
									.font(.system(size: 16))
							}
						}
					}
					.padding(.vertical, 7)
				}
			}
			.padding(.horizontal)

			RectangularButton(title: "Continue") {
				withAnimation {
					state.newVersion = nil
				}
			}
			#if os(macOS) || os(visionOS)
			.buttonStyle(.plain)
			#endif
		}
		.padding()
	}
}
