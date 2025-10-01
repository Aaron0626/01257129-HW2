// Components.swift
// 通用小元件：SectionHeader、ToolBarQuickInfo、ToolChip、TipBubble
import SwiftUI
private let introFontName = "ChenYuluoyan-2.0-Thin"
struct SectionHeader: View {
    let title: String         // 區段標題文字
    let systemImage: String   // SFSymbol 圖示
    let videoURL: URL?        // 單一影片連結（當 videoItems 為空時使用）
    let videoItems: [VideoItem]? // 多部影片

    init(title: String, systemImage: String, videoURL: URL? = nil, videoItems: [VideoItem]? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.videoURL = videoURL
        self.videoItems = videoItems
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 上方圖示 + 標題
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.secondary)
                    .font(.title3)
                    .frame(width: 24)

                Text(title)
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.primary)

                Spacer()
            }

            // 影片連結（多部或單一）
            if let videoItems, !videoItems.isEmpty {
                Text("教學影片")
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.primary)

                let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(videoItems) { v in
                        Link(destination: v.url) {
                            HStack(spacing: 8) {
                                Image(systemName: "play.rectangle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.red)
                                Text(v.title)
                                    .font(.custom(introFontName, size: 25).bold())
                                    .foregroundStyle(.primary)
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
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
                    HStack(spacing: 8) {
                        Image(systemName: "play.rectangle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.red)
                        Text("教學影片連結")
                            .font(.custom(introFontName, size: 25).bold())
                            .foregroundStyle(.primary)
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

/// 上方快速資訊列（今日學習/提醒）
struct ToolBarQuickInfo: View {
    var body: some View {
        HStack(spacing: 12) {
            // 今日學習
            GlassPill {
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                    Text("今日學習？分鐘")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
            }

            // 提醒
            GlassPill {
                HStack(spacing: 8) {
                    Image(systemName: "bell.badge.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .orange)
                    Text("記得放鬆手腕，適時休息")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 75)
        HStack(spacing: 12) {
            // 小技巧（玻璃泡泡）
            TipBubble(
                symbol: "lightbulb.max.fill",
                text: "小技巧：\n保持線的張力一致，針目才會整齊！初學者可先用淺色粗線，較容易看清針目。"
            )
            .font(.custom(introFontName, size: 25).bold())
        }
        .padding(.horizontal, 75)
    }
}
/// 工具小標籤（帶顏色的 SFSymbol 與標籤文字）
struct ToolChip: View {
    let name: String
    let systemImage: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .symbolRenderingMode(.palette)
                .foregroundStyle(color, color.opacity(0.5))
            Text(name)
                .font(.custom(introFontName, size: 25).bold())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(.ultraThinMaterial)
        )
        .overlay(
            Capsule().stroke(.white.opacity(0.15), lineWidth: 1)
        )
    }
}

/// 小技巧泡泡（圖示 + 文字）
struct TipBubble: View {
    let symbol: String // SFSymbol 名稱
    let text: String   // 說明文字

    var body: some View {
        GlassCardBackground(cornerRadius: 18) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: symbol)
                    .font(.title3)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.yellow)
                    .frame(width: 28)

                Text(text)
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
            }
            .padding(14)
        }
    }
}
