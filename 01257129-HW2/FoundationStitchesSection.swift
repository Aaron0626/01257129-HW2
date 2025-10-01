import SwiftUI

private let introFontName = "ChenYuluoyan-2.0-Thin"
struct FoundationStitchesSection: View {
    let title: String
    let intro: String
    let details: [StitchDetail]?
    let videoItems: [VideoItem]?
    let fallbackVideoURL: URL?
    let accent: Color

    @State private var showIntro: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 標題列 + 右上角「介紹」膠囊按鈕
            HStack(alignment: .top) {
                Text(title)
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.primary)

                Spacer()

                GlassPill {
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(accent)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showIntro.toggle()
                    }
                }
            }

            // 介紹內容：若有 details 優先顯示，否則顯示 intro
            if showIntro {
                if let details, !details.isEmpty {
                    GlassCardBackground(cornerRadius: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(details) { item in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.name)
                                        .font(.custom(introFontName, size: 20).bold())
                                        .foregroundStyle(.primary)
                                    Text(item.description)
                                        .font(.custom(introFontName, size: 20).bold())
                                        .foregroundStyle(.secondary)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(.white.opacity(0.12), lineWidth: 1)
                                )
                            }
                        }
                        .padding(12)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                } else if !intro.isEmpty {
                    Text(intro)
                        .font(.custom(introFontName, size: 20).bold())
                        .foregroundStyle(.secondary)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

            // 水平滑動的影片連結塊
            if let items = videoItems, !items.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(items) { v in
                            Link(destination: v.url) {
                                HStack(spacing: 10) {
                                    Image(systemName: "play.rectangle.fill")
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(.red)
                                    Text(v.title)
                                        .font(.custom(introFontName, size: 20).bold())
                                        .foregroundStyle(.primary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .frame(width: 240, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(.white.opacity(0.15), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [.color2.opacity(0.35), .color3.opacity(0.45)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                     )
                     .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                     .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.ultraThinMaterial) // 將毛玻璃作為另一個背景層（但因為漸層已經在底部，這層會疊在漸層上）
                     )
                }
            } else if let url = fallbackVideoURL {
                Link(destination: url) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.rectangle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.red)
                        Text("教學影片連結")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.primary)
                            .font(.custom(introFontName, size: 20).bold())
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        Capsule().fill(.ultraThinMaterial)
                    )
                    .overlay(
                        Capsule().stroke(.white.opacity(0.15), lineWidth: 1)
                    )
                }
            }
        }
    }
}
