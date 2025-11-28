//
//  ContentView.swift
//  FLWhatsNewExample
//
//  Created by Francesco Leoni on 28/11/25.
//

import SwiftUI
import FLWhatsNew

let versionsStore = WhatsNewStore(collection: [
	WhatsNew(
		version: "1.0.0",
		features: [
			Feature(
				title: "Feature 1 title",
				body: "Feature 1 subtitle",
				image: .system("folder.fill")
			),
			Feature(
				title: "Feature 2 title",
				body: "Feature 2 subtitle",
				image: .system("paintbrush.pointed.fill")
			),
			Feature(
				title: "Feature 3 title",
				body: "Feature 3 subtitle",
				image: .system("chart.bar.fill")
			),
			Feature(
				title: "Feature 4 title",
				body: "Feature 4 subtitle",
				image: .system("archivebox.fill")
			),
			Feature(
				title: "Feature 5 title",
				body: "Feature 5 subtitle",
				image: .system("lock.document.fill")
			),
			Feature(
				title: "Feature 6 title",
				body: "Feature 6 subtitle",
				image: .system("waveform.path.ecg.text.page.fill.rtl")
			)
		]
	)
])

struct ContentView: View {

	init() {
		WhatsNewStore.isTesting = true
		WhatsNewStore.configure(.init(appName: "Spotify", brandColor: .black, foregroundColor: .white))
	}

	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundStyle(.tint)
			Text("Hello, world!")
		}
		.padding()
		.showWhatsNew(store: versionsStore) {
			RoundedRectangle(cornerRadius: 20)
				.foregroundStyle(.black)
				.overlay {
					Image(systemName: "tray.fill")
						.font(.largeTitle)
						.foregroundStyle(.white)
				}
		}
	}
}

#Preview {
	ContentView()
}
