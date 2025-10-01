import SwiftUI

// 用來在 ScrollView 內回報垂直捲動偏移量
struct ScrollOffsetPreferenceKey: PreferenceKey {
    /// 預設值為 0，代表尚未捲動。
    static var defaultValue: CGFloat = 0

    /// 合併子視圖回報的偏移量。這裡直接覆蓋為最新值。
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
// 全畫面的背景漸層視圖，會依系統深/淺色模式調整配色。
struct BackgroundGradient: View {
    @Environment(\.colorScheme) private var scheme // 讀取目前色彩模式（深/淺）

    var body: some View {
        ZStack {
            // 基底線性漸層：深色模式偏黑灰、淺色模式偏白與淺灰
            LinearGradient(
                colors: scheme == .dark
                ? [Color.black, Color.gray.opacity(0.35)]
                : [Color(.systemGray6), Color.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // 疊加柔和的彩色暈染，增加畫面層次與活潑感
            RadialGradient(
                colors: [Color.pink.opacity(0.18), Color.purple.opacity(0.12), .clear],
                center: .topLeading,
                startRadius: 20,
                endRadius: 500
            )
            .blendMode(.plusLighter) // 柔和疊加，避免過度搶眼
            .ignoresSafeArea()
        }
    }
}
