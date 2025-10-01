// Cards.swift
// 玻璃擬態樣式與卡片元件集合：GlassCardBackground、GlassPill、ImageCaptionCard、StitchCard、StitchWideCard、DifficultyBadge

import SwiftUI
private let introFontName = "ChenYuluoyan-2.0-Thin"
struct GlassCardBackground<Content: View>: View {
    let cornerRadius: CGFloat                   // 卡片圓角
    let gradientColors: (Color, Color)?         // 若提供則用兩色漸層，否則使用玻璃材質
    @ViewBuilder var content: () -> Content     // 卡片內容

    init(
        cornerRadius: CGFloat = 20,
        gradientColors: (Color, Color)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.gradientColors = gradientColors
        self.content = content
    }

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

            if let colors = gradientColors {
                // 兩色漸層背景（左上 → 右下）
                shape
                    .fill(
                        LinearGradient(
                            colors: [colors.0, colors.1],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
                    .overlay(
                        // 高光描邊
                        shape.strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.45),
                                    .white.opacity(0.2),
                                    .white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                    )
            } else {
                // 原玻璃材質版本
                shape
                    .fill(.ultraThinMaterial)
                    .background(
                        shape
                            .fill(.ultraThinMaterial)
                            .blur(radius: 6)
                            .opacity(0.6)
                    )
                    .overlay(
                        // 高光描邊
                        shape.strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.45),
                                    .white.opacity(0.2),
                                    .white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                    )
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
            }

            content()
        }
    }
}

/// 小型玻璃膠囊（適合小標籤或按鈕）
struct GlassPill<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(
                Capsule().fill(.ultraThinMaterial)
            )
            .overlay(
                Capsule().stroke(.white.opacity(0.15), lineWidth: 1)
            )
    }
}

/// 圖片在上、文字在下的水平卡片（可選擇顯示符號圖例）
/// - 若找不到圖片資產則顯示替代底圖與 SFSymbol
struct ImageCaptionCard: View {
    let item: GalleryItem // 圖片資源與標題
    let accent: Color     // 替代底圖用的主題色

    var body: some View {
        VStack(spacing: 8) {
            // 上方圖片
            Group {
                if UIImage(named: item.imageName) != nil {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 90)
                        .clipped()
                } else {
                    // 替代底圖
                    ZStack {
                        LinearGradient(
                            colors: [accent.opacity(0.35), .blue.opacity(0.25)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        Image(systemName: "photo")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .frame(width: 140, height: 90)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            // 下方標題與符號圖例
            HStack(spacing: 6) {
                if let symbol = item.symbolImageName, UIImage(named: symbol) != nil {
                    Image(symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .stroke(.white.opacity(0.2), lineWidth: 0.5)
                        )
                } else {
                    Image(systemName: "scribble.variable")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Text(item.title)
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .frame(width: 140)
        }
        .padding(8)
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

/// 小卡片（含難度徽章），適合列表或二欄網格
struct StitchCard: View {
    enum Difficulty: String {
        case easy = "入門"
        case medium = "普通"
        case hard = "挑戰"
        var color: Color {
            switch self {
            case .easy: return .green
            case .medium: return .orange
            case .hard: return .red
            }
        }
    }

    // 內容與樣式
    let title: String
    let difficulty: Difficulty
    let description: String
    let assetName: String
    let accent: Color

    var body: some View {
        GlassCardBackground(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 10) {
                // 頂部圖片（或替代底圖）
                ZStack {
                    Group {
                        if UIImage(named: assetName) != nil {
                            Image(assetName)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        } else {
                            ZStack {
                                LinearGradient(
                                    colors: [accent.opacity(0.35), .blue.opacity(0.25)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundStyle(.white.opacity(0.9))
                            }
                            .frame(height: 110)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    // 高光描邊
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }

                // 文字說明
                Text(title)
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(description)
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                // 底部：難度徽章 + 動畫圖示
                HStack {
                    DifficultyBadge(level: difficulty)
                    Spacer()
                    Image(systemName: "scissors")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(accent, accent.opacity(0.5))
                        .font(.system(size: 16, weight: .bold))
                        .symbolEffect(.pulse, options: .repeating, value: title)
                }
                .padding(.top, 2)
            }
            .padding(12)
        }
    }
}

/// 寬卡：左圖右文，支援多部或單一影片連結
struct StitchWideCard: View {
    // 內容與樣式
    let title: String
    let description: String
    let assetName: String
    let videoURL: URL?          // 若 videoItems 為空時使用
    let videoItems: [VideoItem]?// 多部影片
    let accent: Color

    /// 明確初始化以避免推導問題（同時支援單一或多部影片）
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
        GlassCardBackground(cornerRadius: 22) {
            HStack(spacing: 12) {
                // 左側圖片（或替代底圖）
                ZStack {
                    Group {
                        if UIImage(named: assetName) != nil {
                            Image(assetName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipped()
                        } else {
                            LinearGradient(
                                colors: [accent.opacity(0.35), .purple.opacity(0.25)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(width: 110, height: 110)
                            .overlay(
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundStyle(.white.opacity(0.9))
                            )
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                }

                // 右側文字與操作
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.custom(introFontName, size: 25).bold())
                        .foregroundStyle(.primary)

                    Text(description)
                        .font(.custom(introFontName, size: 25))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)

                    // 教學影片：多部或單一
                    if let videoItems, !videoItems.isEmpty {
                        Text("教學影片")
                            .font(.custom(introFontName, size: 25).bold())
                            .foregroundStyle(.primary)
                            .padding(.top, 2)

                        let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
                        LazyVGrid(columns: columns, spacing: 12) {
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
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(12)
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

/// 難度徽章（依等級變換顏色與圖示）
struct DifficultyBadge: View {
    let level: StitchCard.Difficulty

    var body: some View {
        Label(level.rawValue, systemImage: level == .easy ? "leaf.fill" : (level == .medium ? "flame.fill" : "bolt.fill"))
            .font(.caption.weight(.semibold))
            .labelStyle(.titleAndIcon)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(level.color.opacity(0.15))
            )
            .overlay(
                Capsule().stroke(level.color.opacity(0.35), lineWidth: 1)
            )
            .foregroundStyle(level.color)
    }
}
