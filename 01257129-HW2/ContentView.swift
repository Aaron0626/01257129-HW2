import SwiftUI
private let introFontName = "ChenYuluoyan-2.0-Thin"
struct ContentView: View {
    @State private var isDarkMode: Bool = false
    @State private var animateScissors: Bool = false
    @AppStorage("isSubscribed") private var isSubscribed: Bool = false

    // 兩欄網格設定（目前未使用，如需恢復卡片區可再用）
    private let grid = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    // 捲動偏移與底部列透明度
    @State private var scrollOffset: CGFloat = 0
    @State private var bottomBarOpacity: Double = 1.0
    // 底部列選中索引（僅改變外觀，無實際功能）
    @State private var selectedTabIndex: Int = 0

    var body: some View {
        ZStack {
            Image("Image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // 用來回報捲動偏移（置於內容最上方）
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .named("mainScroll")).minY
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: -minY)
                    }
                    .frame(height: 0)

                    // 頂部 Hero Header（ZStack + 玻璃擬態 + SFSymbol 動畫）
                    HeaderView(
                        title: "鉤織入門指南",
                        subtitle: "從入門到熟練，輕鬆學會鉤針針法！",
                        bgImageName: "crochet_hero",   // 請在 Assets 放一張圖，名稱：crochet_hero
                        isDarkMode: $isDarkMode,
                        animateScissors: $animateScissors,
                        isSubscribed: $isSubscribed
                    )
                    .padding(.horizontal, 75)
                    .padding(.top, 0)

                    ToolBarQuickInfo()
                    
                    // 基礎針法
                    GlassPill {
                        HStack(spacing: 8) {
                            Image(systemName: "square.grid.2x2.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.gray)
                            Text("基礎針法")
                                .font(.custom(introFontName, size: 35).bold())
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 80)
                    }

                    VStack(spacing: 16) {
                        // 起立針、鎖針、環形起針、引拔針：改為保留介紹 + 水平影片連結塊（無圖片）
                        FoundationStitchesSection(
                            title: "起立針、鎖針、環形起針、\n引拔針",
                            intro: "",
                            details: [
                                StitchDetail(name: "起立針", description: "整個編織的第一步，可分為鎖針起針和環狀起針。"),
                                StitchDetail(name: "鎖針（CH）", description: "最基礎的針法，用於開始編織或製作裝飾性的網狀結構。"),
                                StitchDetail(name: "環形起針（Magic Ring）", description: "從一個小圓的中心開始鉤針，用於製作立體、圓形展開的作品，例如娃娃、帽子、杯墊等。"),
                                StitchDetail(name: "引拔針（SL/Slst）", description: "用於收尾、連接與移位，幾乎不增加高度，邊緣俐落。")
                            ],
                            videoItems: [
                                VideoItem(title: "起立針教學", url: URL(string: "https://youtu.be/WpeC5peABBw?si=jDkesSxI5fl6RFtm")!),
                                VideoItem(title: "鎖針教學", url: URL(string: "https://youtu.be/mw1D2in11Mw?si=jzXcPv8snY-TeMLN")!),
                                VideoItem(title: "環形起針教學", url: URL(string: "https://youtu.be/zS2b27O7pc4?si=wONxh6EkgYbaZwaF")!),
                                VideoItem(title: "引拔針教學", url: URL(string: "https://youtu.be/LyyDQeCVwfY?si=MiNR6KqUHAbg282O")!)
                            ],
                            fallbackVideoURL: URL(string: "https://www.youtube.com/results?search_query=crochet+foundation+chain+magic+ring+slip+stitch")!,
                            accent: .teal
                        )

                        BasicStitchSubsection(
                            title: "短針（X）",
                            intro: "織物最密實、最堅固，針目最小。常用於玩偶、包包等，也適合用於織物邊緣的收尾。\n起立鎖針：\n每行開始時通常勾 1 針鎖針作為起立針。",
                            stepImageName: "stitch_sc_step",
                            videoURL: URL(string: "https://www.youtube.com/watch?v=uS-v0UN4v2Q&t=11s")!,
                            exampleImageNames: ["sc_example1", "sc_example2", "sc_example3"],
                            accent: .pink
                        )
                        Spacer()
                        BasicStitchSubsection(
                            title: "中長針（T）",
                            intro: "介於短針和長針之間，能創造出比短針更具彈性的織紋，編織速度快、質地柔軟，是許多衣物與毯子的好選擇。\n起立鎖針： 每行開始時通常勾 2 針鎖針作為起立針。",
                            stepImageName: "stitch_hdc_step",
                            videoURL: URL(string: "https://www.youtube.com/watch?v=uS-v0UN4v2Q&t=158s")!,
                            exampleImageNames: ["hdc_example1", "hdc_example2", "hdc_example3"],
                            accent: .mint
                        )
                        Spacer()
                        BasicStitchSubsection(
                            title: "長針（F）",
                            intro: "織出的針目較高，比短針的速度更快、透氣性佳，常見於披肩、圍巾與開放式花樣。\n起立鎖針： 每行開始時通常勾 3 針鎖針作為起立針。",
                            stepImageName: "stitch_dc_step",
                            videoURL: URL(string: "https://www.youtube.com/watch?v=uS-v0UN4v2Q&t=329s")!,
                            exampleImageNames: ["dc_example1", "dc_example2", "dc_example3", "dc_example4"],
                            accent: .indigo
                        )
                        Spacer()
                        BasicStitchSubsection(
                            title: "長長針（E）",
                            intro: "織出的針目更高，能快速完成大面積的織物、堆疊高度，常用於華麗花樣與鏤空設計。\n起立鎖針： 每行開始時通常勾 4 針鎖針 (ch 4) 作為起立針。",
                            stepImageName: "stitch_tr_step",
                            videoURL: URL(string: "https://www.youtube.com/watch?v=uS-v0UN4v2Q&t=541s")!,
                            exampleImageNames: ["tr_example1", "tr_example2"],
                            accent: .orange
                        )
                    }
                    .padding(.horizontal, 85)
                    .padding(.top, 15)
                    .padding(.bottom, 12)
                    .background(Color.color1)
                    .shadow(radius: 10)
                    
                    TipBubble(
                        symbol: "medal.star",
                        text: "恭喜您！學會以上的基礎針法，您已經是一位初學者了，讓我們朝著鉤織大師之路繼續邁進吧！"
                    )
                    .padding(.horizontal, 75)
                    Spacer()
                    // 進階針法
                    GlassPill {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.gray)
                            Text("進階針法")
                                .font(.custom(introFontName, size: 35).bold())
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 80)
                    }
                    // 水平滑動（圖在上、文在下）
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            StitchTallCard(
                                title: "泡泡針／棗形針（Bobble Stitch）",
                                description: "將多個長針或中長針在同一針眼上織出，然後一次將所有有針眼收拢的立體編織技法，形成的纹理像一串小小的、圓潤的棗子或氣泡，立體感強，能為織物增添厚重感和裝飾性。",
                                assetName: "stitch_bobble",
                                videoURL: URL(string: "https://youtu.be/L7zfo93Jx6g?si=rwC7Wzl2ofU0ir2D"),
                                accent: .orange
                            )
                            StitchTallCard(
                                title: "玉米花針／爆米花針（Popcorn Stitch）",
                                description: "與泡針相似，也是在同一針目上鉤織多針後一次性收口，但通常使用的針法是長針或長長針，形成凸起、顆粒狀的紋理，形狀像爆米花或玉米粒，比泡泡針更突起，立體果顯著。",
                                assetName: "stitch_popcorn",
                                videoURL: URL(string: "https://youtu.be/KPXE6kJXcnc?si=XG8IuAJAAHiXmJfY"),
                                accent: .yellow
                            )
                            StitchTallCard(
                                title: "扇形針\n（Fan Stitch）",
                                description: "與貝殼針相似，在同一針目或附近的針目上鉤織一排不同長度的針目，形成一個半圓形的扇形，像開啟的扇子，針目從中心向外展開，但更強調層次與張力的變化。",
                                assetName: "stitch_fan",
                                videoURL: URL(string: "https://youtu.be/mZhHZKtx334?si=pTEiuj8iaLfQMnRD"),
                                accent: .mint
                            )
                            StitchTallCard(
                                title: "貝殼針\n（Shell Stitch）",
                                description: "利用編織中的重複性設計，在針目與針目與針目之間形成具有或扇形外觀秂的圖案，質感像展開的貝殼，富有層感。很適合用作包包的花紋。",
                                assetName: "stitch_shell",
                                videoURL: URL(string: "https://www.youtube.com/watch?v=rmBOcphmiPM&pp=ygUP6LKd5q686Yed5pWZ5a24"),
                                accent: .purple
                            )
                            StitchTallCard(
                                title: "七寶針\n (Solomon's Knot)",
                                description: "以重複的花瓣或扇形組成的圓花圖樣，層次豐富，常用於杯墊、披肩與裝飾邊。",
                                assetName: "stitch_seven_treasure",
                                videoURL: URL(string: "https://youtu.be/yOizN3RN0r4?si=0t_ktqgFJWN06Bcd"),
                                accent: .teal
                            )
                            StitchTallCard(
                                title: "葉子針\n（Leaf Stitch)",
                                description: "呈現葉片或葉脈的紋理，可以是獨立的葉片圖案或重複的葉脈花紋",
                                assetName: "stitch_leaf",
                                videoURL: URL(string: "https://youtu.be/r0_kUpO5Ds0?si=YwxgSc1FrMpq58yU"),
                                accent: .mint
                            )
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.color1)
                                .shadow(radius: 10)
                        )
                        .padding(.horizontal, 85)
                        .padding(.vertical, 12)
                    }

                    Spacer()
                    
                    GlassPill {
                        HStack(spacing: 8) {
                            Image(systemName: "atom")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.gray)
                            Text("常用工具")
                                .font(.custom(introFontName, size: 35).bold())
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal, 80)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ToolChip(name: "鉤針", systemImage: "wand.and.sparkles.inverse", color: .cyan)
                            ToolChip(name: "毛線", systemImage: "gyroscope", color: .teal)
                            ToolChip(name: "縫針", systemImage: "wand.and.outline.inverse", color: .purple)
                            ToolChip(name: "剪刀", systemImage: "scissors", color: .red)
                            ToolChip(name: "記號扣", systemImage: "paperclip", color: .orange)
                        }
                        .padding(.horizontal, 75)
                    }
                    // 結語
                    GlassCardBackground(cornerRadius: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("開始你的鉤織旅程")
                                .font(.custom(introFontName, size: 25).bold())
                                .foregroundStyle(.primary)
                            Text("從基礎練習開始，慢慢建立肌肉記憶。別害怕拆掉重來，每一針都會讓你更進步！")
                                .foregroundStyle(.secondary)
                                .font(.custom(introFontName, size: 25).bold())
                            HStack(spacing: 8) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.yellow)
                                    .symbolEffect(.pulse, options: .repeating, value: isDarkMode)
                                Text("祝編織愉快！")
                                    .font(.custom(introFontName, size: 25).bold())
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.top, 4)
                        }
                        .padding(16)
                    }
                    .padding(.horizontal, 75)
                    .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
            .coordinateSpace(name: "mainScroll") // 供捲動偏移計算
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
                // 捲越多越淡；最低保留 0.35 的可見度
                let fade = max(0.35, min(1.0, 1.0 - (value / 300.0)))
                withAnimation(.easeInOut(duration: 0.2)) {
                    bottomBarOpacity = fade
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .safeAreaInset(edge: .bottom) {
            BottomActionBar(selectedIndex: $selectedTabIndex, opacity: bottomBarOpacity)
                .padding(.horizontal, 0) // 與系統 TabBar 一樣貼齊邊
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.2)) {
                animateScissors = true
            }
        }
    }
}
#Preview("Light") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .preferredColorScheme(.dark)
}
