import SwiftUI

/// 垂直卡片：上圖下文，支援單一或多部影片連結
private let introFontName = "ChenYuluoyan-2.0-Thin"
struct StitchTallCard: View {
    let title: String
    let description: String
    let assetName: String
    let videoURL: URL?          // 若 videoItems 為空時使用
    let videoItems: [VideoItem]?
    let accent: Color

    init(
        title: String,
        description: String,
        assetName: String,
        videoURL: URL? = nil,
        videoItems: [VideoItem]? = nil,
        accent: Color
    ) {
        self.title = title
        self.description = description
        self.assetName = assetName
        self.videoURL = videoURL
        self.videoItems = videoItems
        self.accent = accent
    }

    var body: some View {
        GlassCardBackground(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 10) {
                // 上方圖片（或替代底圖）
                ZStack {
                    Group {
                        if UIImage(named: assetName) != nil {
                            Image(assetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 230)
                                .clipped()
                        } else {
                            LinearGradient(
                                colors: [accent.opacity(0.35), .purple.opacity(0.25)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(height: 140)
                            .overlay(
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundStyle(.white.opacity(0.9))
                            )
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                }

                // 下方文字
                Text(title)
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(description)
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                // 影片：多部或單一
                if let videoItems, !videoItems.isEmpty {
                    Text("教學影片")
                        .font(.custom(introFontName, size: 25).bold())
                        .foregroundStyle(.primary)
                        .padding(.top, 2)

                    VStack(spacing: 8) {
                        ForEach(videoItems) { v in
                            Link(destination: v.url) {
                                HStack(spacing: 8) {
                                    Image(systemName: "play.rectangle.on.rectangle.fill")
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(.red)
                                    Text(v.title)
                                        .font(.custom(introFontName, size: 25).bold())
                                        .foregroundStyle(.primary)
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(.white.opacity(0.15), lineWidth: 1)
                                )
                            }
                        }
                    }
                } else if let videoURL {
                    Link(destination: videoURL) {
                        HStack(spacing: 6) {
                            Image(systemName: "play.rectangle.on.rectangle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.red)
                            Text("教學影片")
                                .font(.custom(introFontName, size: 25).bold())
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(.ultraThinMaterial)
                        )
                        .overlay(
                            Capsule().stroke(.white.opacity(0.15), lineWidth: 1)
                        )
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(width: 260) // 給水平列表一個固定寬度，視覺更整齊
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.color3.opacity(0.45), accent.opacity(0.35)],
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
                    .fill(.ultraThinMaterial)
            )
        }
    }
}
