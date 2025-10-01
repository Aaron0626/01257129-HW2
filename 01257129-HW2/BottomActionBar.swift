// BottomActionBar.swift
// 底部工具列（外觀近似系統 TabBar，僅切換選中狀態，無實際導航）
import SwiftUI
private let introFontName = "ChenYuluoyan-2.0-Thin"
/// 底部工具列：依據 selectedIndex 切換選中外觀，並可隨捲動改變整體透明度。
struct BottomActionBar: View {
    @Binding var selectedIndex: Int // 當前選中的索引（由外部持有）
    let opacity: Double             // 整體透明度（通常隨 Scroll 淡出）
    /// 顯示的按鈕項目（標題 + SFSymbol）
    /// 注意：選中時會使用資產色 Color.color（你的 Assets 名為 "color"）
    private let items: [BottomActionItem] = [
        .init(title: "首頁", systemImage: "house"),
        .init(title: "針法", systemImage: "command"),
        .init(title: "新增", systemImage: "plus.app"),
        .init(title: "收藏", systemImage: "bookmark"),
        .init(title: "我的", systemImage: "person.crop.circle")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { idx in
                let isSelected = idx == selectedIndex
                Button {
                    // 僅切換選中外觀（不處理導航）
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedIndex = idx
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: items[idx].systemImage + (isSelected ? ".fill" : ""))
                            .font(.system(size: 20, weight: .semibold))
                        Text(items[idx].title)
                            .font(.custom(introFontName, size: 25).bold())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .foregroundStyle(isSelected ? Color.color : .secondary) // 使用資產色 "color"
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.bottom, 6)     // 與 Home 指示器保持距離
        .background(.regularMaterial) // 模糊材質，接近系統 TabBar
        .overlay(
            // 頂部髮絲分隔線
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .frame(height: 0.5),
            alignment: .top
        )
        .opacity(opacity)
    }
}

/// 底部工具列的資料模型
struct BottomActionItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let systemImage: String
}

/// 單一底部按鈕（若未使用也可保留供日後擴充）
struct BottomActionButton: View {
    let title: String
    let systemImage: String

    var body: some View {
        Button(action: {}) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .font(.custom(introFontName, size: 25).bold())
            }
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
    }
}
