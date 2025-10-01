// HeaderView.swift
// 頂部 Hero Header：背景圖/漸層 + 訂閱/主題切換 + 標題與副標
import SwiftUI
private let introFontName = "ChenYuluoyan-2.0-Thin"
struct HeaderView: View {
    let title: String          // 主標題
    let subtitle: String       // 副標題
    let bgImageName: String    // 背景圖片（Assets 名稱）
    @Binding var isDarkMode: Bool        // 是否為深色模式（與 ContentView 同步）
    @Binding var animateScissors: Bool   // 用於控制圖示動畫的狀態
    @Binding var isSubscribed: Bool      // 訂閱狀態（@AppStorage 在外層綁定）

    var body: some View {
        ZStack(alignment: .top) {
            // 背景：優先使用圖片，否則用漸層替代
            Group {
                if UIImage(named: bgImageName) != nil {
                    Image(bgImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 170)
                        .clipped()
                } else {
                    LinearGradient(
                        colors: [Color.pink.opacity(0.6), Color.purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 170)
                }
            }

            // 下方遮罩漸層：提升文字可讀性
            LinearGradient(
                colors: [Color.black.opacity(0.35), Color.black.opacity(0.1)],
                startPoint: .bottom,
                endPoint: .top
            )
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // 訂閱狀態膠囊
                    GlassPill {
                        HStack(spacing: 8) {
                            if isSubscribed {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.yellow, .orange)
                                    .symbolEffect(.bounce, options: .repeating, value: animateScissors)
                                Text("訂閱")
                                    .font(.custom(introFontName, size: 20).bold())
                                    .foregroundStyle(.white.opacity(0.9))
                            } else {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.green, .teal)
                                Text("已訂閱")
                                    .font(.custom(introFontName, size: 20).bold())
                                    .foregroundStyle(.white.opacity(0.95))
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                    }
                    .onTapGesture {
                        // 切換訂閱狀態與觸覺回饋
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                            isSubscribed.toggle()
                        }
                    }
                    .sensoryFeedback(isSubscribed ? .success : .selection, trigger: isSubscribed)

                    Spacer()

                    // 深/淺色模式切換
                    GlassPill {
                        HStack(spacing: 8) {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(isDarkMode ? .yellow.opacity(0.9) : .orange.opacity(0.9))
                                .frame(width: 18)
                            Text(isDarkMode ? "Dark" : "Light")
                                .font(.custom(introFontName, size: 20).bold())
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                                isDarkMode.toggle()
                            }
                        }
                    }
                }
                // 標題與副標
                Text(title)
                    .font(.custom(introFontName, size: 40).bold())
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)

                Text(subtitle)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 12)
    }
}
