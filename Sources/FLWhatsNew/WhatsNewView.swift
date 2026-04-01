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
#if os(iOS)
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

	public init(version: WhatsNew, appReviewURL: String? = nil, @ViewBuilder icon: @escaping () -> Icon, onClose: (() -> Void)? = nil) {
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
					.frame(width: 70, height: 70)
				#else
					.frame(width: 80, height: 80)
				#endif
					.padding(.bottom, 8)

				Group {
					if let appName = config.appName {
            Text(String(
              format: NSLocalizedString("whatsNewIn", bundle: .module, comment: ""),
              appName
          ))
					} else {
            Text("whatsNew", bundle: .module)
					}
				}
				.foregroundColor(.primary)
				.multilineTextAlignment(.center)
				.font(.title.bold())
			}
			.padding(.top)

			FadingScrollView {
				VStack(alignment: .leading, spacing: 20) {
					ForEach(version.features) { feature in
						HStack(spacing: 16) {
							switch feature.image {
							case .named(let name):
								Image(name)
									.resizable()
									.scaledToFit()
									.frame(width: 35, height: 35)
									.foregroundColor(config.brandColor)

							case .system(let name):
								Image(systemName: name)
									.font(.title)
									.frame(width: 35, height: 35)
									.foregroundColor(config.brandColor)
							}

							VStack(alignment: .leading) {
								Text(feature.title)
									.font(.body.bold())
									.fixedSize(horizontal: false, vertical: true)
									.frame(maxWidth: .infinity, alignment: .leading)

								Text(feature.body)
									.font(.body)
									.fixedSize(horizontal: false, vertical: true)
									.frame(maxWidth: .infinity, alignment: .leading)
							}
						}
					}
				}
			}
			.padding(.horizontal)

			if let appReviewURL, let url = URL(string: appReviewURL) {
        RectangularButton(title: String(localized: "rateApp", bundle: .module), color: config.brandColor, foreground: config.foregroundColor) {
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
          Text("maybeLater", bundle: .module)
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
		.frame(width: 400, height: 550)
#else
		.frame(maxWidth: 500)
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

public struct WhatsNewBoldView<Icon: View>: View {

  @ObservedObject var keyboard = KeyboardObserver()

  var version: WhatsNew
  var appReviewURL: String?
  @ViewBuilder var icon: () -> Icon
  var onClose: (() -> Void)?

  private let config = WhatsNewStore.Config.shared

  public init(version: WhatsNew, appReviewURL: String? = nil, @ViewBuilder icon: @escaping () -> Icon, onClose: (() -> Void)? = nil) {
    self.version = version
    self.appReviewURL = appReviewURL
    self.icon = icon
    self.onClose = onClose
  }

  public var body: some View {
    ZStack {
      Color("whatsnew.back", bundle: .module)
        .ignoresSafeArea()
      
      ScrollView(showsIndicators: false) {
        VStack(alignment: .center) {
          VStack(alignment: .center) {
            icon()
#if os(macOS)
              .frame(width: 60, height: 60)
#else
              .frame(width: 70, height: 70)
#endif
              .padding(.bottom, 4)
            
            Group {
              if let appName = config.appName {
                Text(String(
                  format: NSLocalizedString("whatsNewIn", bundle: .module, comment: ""),
                  appName
                ))
              } else {
                Text("whatsNew", bundle: .module)
              }
            }
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
            .font(.title.bold())
          }
          .padding(.vertical)
          
          VStack(alignment: .leading, spacing: 20) {
            ForEach(version.features) { feature in
              VStack(spacing: 0) {
                VStack {
                  switch feature.image {
                  case .named(let name):
                    Image(name)
                      .resizable()
                      .scaledToFit()
#if os(macOS)
                      .frame(height: 140)
#else
                      .frame(height: 160)
#endif
                      .foregroundColor(.white)
                    
                  case .system(let name):
                    Image(systemName: name)
                      .font(.system(size: 60))
                      .foregroundColor(.white)
                  }
                }
#if os(macOS)
                .frame(height: 140)
#else
                .frame(height: 160)
#endif
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: [config.secondaryColor.opacity(0.8), config.secondaryColor], startPoint: .top, endPoint: .bottom), in: .rect)
                
                VStack(alignment: .center, spacing: 4) {
                  Text(feature.title)
                    .font(.title2.bold())
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .center)
                  
                  Text(feature.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .multilineTextAlignment(.center)
                .padding(24)
              }
              .background(Color("whatsnew.white", bundle: .module), in: .rect(cornerRadius: 20))
              .clipShape(.rect(cornerRadius: 20))
            }
          }
          .padding(.horizontal)
        }
        .padding()
      }
      .safeAreaInset(edge: .bottom) {
        VStack {
          if let appReviewURL, let url = URL(string: appReviewURL) {
            RectangularButton(title: String(localized: "rateApp", bundle: .module), color: config.brandColor, foreground: config.foregroundColor) {
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
              Text("maybeLater", bundle: .module)
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
        .background(Color("whatsnew.back", bundle: .module))
      }
    }
#if os(macOS)
    .frame(width: 400, height: 550)
#else
    .frame(maxWidth: 500)
    .sheetBackground(Color("whatsnew.back", bundle: .module))
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

struct FadingScrollView<Content: View>: View {

	var content: Content
	var fadeHeight: CGFloat
	var showsIndicators: Bool

	init(@ViewBuilder content: () -> Content, fadeHeight: CGFloat = 20, showsIndicators: Bool = false) {
		self.content = content()
		self.fadeHeight = fadeHeight
		self.showsIndicators = showsIndicators
	}

	var body: some View {
		ScrollView(showsIndicators: showsIndicators) {
			content
				.padding(.vertical, fadeHeight)
		}
		.mask(
			VStack(spacing: 0) {
				LinearGradient(
					gradient: Gradient(colors: [.black.opacity(0), .black]),
					startPoint: .top,
					endPoint: .bottom
				)
				.frame(height: fadeHeight)

				Rectangle()
					.fill(.black)

				LinearGradient(
					gradient: Gradient(colors: [.black, .black.opacity(0)]),
					startPoint: .top,
					endPoint: .bottom
				)
				.frame(height: fadeHeight)
			}
		)
	}
}

extension View {
  
  @ViewBuilder
  func sheetBackground(_ color: Color) -> some View {
    if #available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *) {
      presentationBackground(color)
    } else {
      self
    }
  }
}

#Preview {
	WhatsNewBoldView(version: .init(version: "1.0.0", features: [Feature(id: "1", title: "Checklists", body: "Now you can add checklists to your notes.", image: .system("checklist")), Feature(id: "3", title: "This is the title", body: "This is the body.", image: .system("plus")), Feature(id: "2", title: "This is the title", body: "This is the body.", image: .system("plus")), Feature(id: "4", title: "This is the title", body: "This is the body.", image: .system("plus"))]), appReviewURL: "nil") {
		Image(systemName: "plus")
			.foregroundColor(.white)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color.black)
			.clipShape(.rect(cornerRadius: 20))
	} onClose: {

	}
}
