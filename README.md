# FLWhatsNew

## Configuration

### Specify the configuration
```swift
		WhatsNewStore.configure(.init(appName: "My App", brandColor: .black, foregroundColor: .white))
```

### Display the screen
```swift
let versionsStore = WhatsNewStore(collection: [
	// Version configurations...
]

var body: some View {
	content
		.showWhatsNew(store: versionsStore, appReviewURL: "https://url.to.appstore") {
			Image("app")
				.resizable()
				.scaledToFit()
				.clipShape(.rect(cornerRadius: 20))
				.overlay {
						RoundedRectangle(cornerRadius: 20)
							.stroke(.white.opacity(0.1), lineWidth: 1)
				}
		}
}
```

### Set testing
If you need to see the WhatsNew screen while testing.
```swift
WhatsNewStore.isTesting = true
```
