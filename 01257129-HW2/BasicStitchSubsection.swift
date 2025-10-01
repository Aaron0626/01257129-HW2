// BasicStitchSubsection.swift
// 基礎針法小節：標題 + 介紹（可展開）+ 圖片/影片 + 作品範例 + 可選的圖文卡片列表

import SwiftUI
private let introFontName = "ChenYuluoyan-2.0-Thin"
/// 基礎針法小節（可選多段說明、圖文卡片、單一或多部影片）
struct BasicStitchSubsection: View {
    // 主要文案與樣式
    let title: String                  // 小節標題
    let intro: String                  // 簡短介紹（若 details 為 nil 時顯示）
    let stepImageName: String          // 步驟圖片（Assets 名稱）
    let videoURL: URL                  // 單一影片連結（若 videoItems 為 nil 時使用）
    let exampleImageNames: [String]    // 作品範例圖（Assets 名稱陣列）
    let accent: Color                  // 主題色（用於佈景與替代圖）

    // 可選內容
    let details: [StitchDetail]?       // 多段針法說明（展開時顯示）
    let galleryItems: [GalleryItem]?   // 圖片在上、文字在下的水平卡片
    let videoItems: [VideoItem]?       // 多部教學影片（若存在則覆蓋單一 videoURL）

    // UI 狀態
    @State private var showIntro: Bool = false // 是否展開介紹區

    /// 自訂初始化（提供可選參數的預設值）
    init(
        title: String,
        intro: String,
        stepImageName: String,
        videoURL: URL,
        exampleImageNames: [String],
        accent: Color,
        details: [StitchDetail]? = nil,
        galleryItems: [GalleryItem]? = nil,
        videoItems: [VideoItem]? = nil
    ) {
        self.title = title
        self.intro = intro
        self.stepImageName = stepImageName
        self.videoURL = videoURL
        self.exampleImageNames = exampleImageNames
        self.accent = accent
        self.details = details
        self.galleryItems = galleryItems
        self.videoItems = videoItems
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 標題列 + 右上角「介紹」膠囊按鈕
            HStack(alignment: .top) {
                Text(title)
                    .font(.custom(introFontName, size: 25).bold())
                    .foregroundStyle(.primary)

                Spacer()

                // 介紹膠囊（點擊展開/收起）
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

            // 介紹內容：優先顯示 details，否則顯示 intro 文字
            if showIntro {
                if let details, !details.isEmpty {
                    GlassCardBackground(cornerRadius: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(details) { item in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.name)
                                        .font(.custom(introFontName, size: 25).bold())
                                        .foregroundStyle(.primary)
                                    Text(item.description)
                                        .font(.custom(introFontName, size: 25).bold())
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
                    .transition(AnyTransition.opacity.combined(with: AnyTransition.move(edge: .top)))
                } else if !intro.isEmpty {
                    Text(intro)
                        .font(.custom(introFontName, size: 25).bold())
                        .foregroundStyle(.secondary)
                        .transition(AnyTransition.opacity.combined(with: AnyTransition.move(edge: .top)))
                }
            }

            // 可選：圖文卡片水平滑動
            if let items = galleryItems, !items.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(items) { item in
                            ImageCaptionCard(item: item, accent: accent)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            // 主要內容卡片：步驟圖 + 影片（單一或多部）+ 作品範例（還原為玻璃材質）
            GlassCardBackground(cornerRadius: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    // 步驟圖片（若無資產則顯示替代圖）
                    Group {
                        if UIImage(named: stepImageName) != nil {
                            Image(stepImageName)
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
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    // 教學影片：多部或單一連結
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
                                        Image(systemName: "play.rectangle.on.rectangle")
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
                    } else {
                        // 單一影片連結
                        Link(destination: videoURL) {
                            HStack(spacing: 8) {
                                Image(systemName: "play.rectangle.on.rectangle")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.red)
                                Text("教學影片連結")
                                    .font(.custom(introFontName, size: 25).bold())
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

                    // 作品範例（水平滑動）
                    Text("作品範例")
                        .font(.custom(introFontName, size: 25).bold())
                        .foregroundStyle(.primary)
                        .padding(.top, 4)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(exampleImageNames, id: \.self) { name in
                                GlassCardBackground(cornerRadius: 16) {
                                    Group {
                                        if UIImage(named: name) != nil {
                                            Image(name)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 230)
                                                .clipped()
                                        } else {
                                            ZStack {
                                                LinearGradient(
                                                    colors: [accent.opacity(0.35), .color2.opacity(0.25)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                                Image(systemName: "photo")
                                                    .font(.system(size: 22, weight: .semibold))
                                                    .foregroundStyle(.white.opacity(0.9))
                                            }
                                            .frame(width: 230)
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [accent.opacity(0.35), .purple.opacity(0.45)],
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
        }
    }
}
