# 鉤織入門指南 (Crochet Starter Guide)

以 SwiftUI 打造的鉤織入門教學 App：從「入門四法」到「基礎與進階針法」，整合步驟圖、作品範例與教學影片，幫助初學者循序漸進學習。

<img width="512" height="512" alt="截圖 2025-10-03 晚上8 46 32" src="https://github.com/user-attachments/assets/1a3c85c9-badf-460b-870a-af5e08bd25a1" />

⸻

## 特色
* Header：頂部大圖與玻璃擬態卡片，內含主題切換（Light/Dark）與訂閱徽章。
* 入門四法：起立針、鎖針、環形起針、引拔針，整合文字與多部教學影片，並提供影片連結。
* 基礎針法：短針／中長針／長針／長長針，包含步驟圖、教學影片與作品範例。
* 進階針法：泡泡針/棗行針、爆米花針、扇形針、貝殼針、七寶針、葉子針，以直式卡片水平展示，且附有教學影片。
* 常用工具：以 Tool Chips 呈現鉤針、毛線、縫針、剪刀、記號扣等。
* 自訂字型：採用 ChenYuluoyan-2.0-Thin，營造手作風格。

⸻

專案結構
* ContentView.swift􀰓：主畫面、捲動偏移回報、底部工具列淡出
* HeaderView.swift􀰓：頂部 Hero Header（訂閱徽章、主題切換、標題/副標）
* BasicStitchSubsection.swift􀰓：基礎針法子區塊（標題、介紹、步驟圖、影片、作品範例、可選圖文卡片）
* FoundationStitchesSection.swift􀰓：入門四法專區（介紹、影片連結、fallback）
* StitchTallCard.swift􀰓：進階針法直式卡片（圖上文下、單或多影片）
* Cards.swift􀰓：視覺與容器元件（GlassCardBackground, GlassPill, ImageCaptionCard, StitchCard, StitchWideCard, DifficultyBadge）
* Components.swift􀰓：通用小元件（SectionHeader, ToolBarQuickInfo, ToolChip, TipBubble）
* BottomActionBar.swift􀰓：底部工具列（外觀近似系統 TabBar，僅切換選中狀態）
* Utilities.swift􀰓：ScrollOffsetPreferenceKey（捲動偏移回報）、BackgroundGradient
* Models.swift􀰓：資料模型（GalleryItem, StitchDetail, VideoItem）
  
⸻

## 畫面一覽
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-10-05 at 02 47 47" src="https://github.com/user-attachments/assets/d498cebf-68ee-4467-b9a7-b08329b34d8b" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-10-05 at 02 48 03" src="https://github.com/user-attachments/assets/4ec10704-0125-49a7-9aba-9c8224ec02c9" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-10-05 at 02 48 12" src="https://github.com/user-attachments/assets/ac64bc4d-5082-4a44-9817-734358439324" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-10-05 at 02 48 20" src="https://github.com/user-attachments/assets/ef7007c0-a051-4c41-8267-ee59661f8a4a" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-10-05 at 02 48 32" src="https://github.com/user-attachments/assets/c3005ce9-1804-4d97-bdd8-17c76a02bb40" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-10-05 at 02 48 40" src="https://github.com/user-attachments/assets/7e40f2fb-c47a-49a5-9fce-86dfb89e5e13" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-10-05 at 02 48 45" src="https://github.com/user-attachments/assets/870bcf07-584f-422f-9f8e-a166a3dc99c5" />

⸻

技術重點
* SwiftUI 全介面：ScrollView、safeAreaInset、symbolEffect、ultraThinMaterial、palette/hierarchical 渲染
* 捲動偏移監測：GeometryReader + PreferenceKey (ScrollOffsetPreferenceKey) 回報捲動量，動畫調整底部列透明度
* 玻璃擬態與漸層：多層背景、描邊與陰影，並以可重用容器（GlassCardBackground, GlassPill）統一風格
* 字型統一：全域常數 introFontName = "ChenYuluoyan-2.0-Thin"

⸻

## 資產與設定
* 圖片資產（放入 Assets 並確保命名一致）
   * 背景／主視覺：crochet_hero
   * 基礎針法步驟圖：stitch_sc_step, stitch_hdc_step, stitch_dc_step, stitch_tr_step
   * 作品／示例／卡片用圖：sc_example1/2/3, hdc_example1/2/3, dc_example1/2/3/4, tr_example1/2 等
* 自訂字型
   * 字型檔：ChenYuluoyan-2.0-Thin.ttf（或同名）
   * 將字型加入專案並於 Info.plist 的 UIAppFonts 註冊
   * 程式使用的名稱：ChenYuluoyan-2.0-Thin
* 顏色資產 / Color 擴充
   * 需提供：Color.color1, Color.color2, Color.color3, Color.color（底部工具列選中顏色）
   * 建議在 Assets 建立 Color Set（Light/Dark 皆提供），或撰寫 Color 擴充回傳對應顏色
     
⸻

## 安裝與執行
1. 下載或 Clone 專案後，以 Xcode 15+ 開啟。
2. 確認已加入必要資產（見下方「資產與設定」）。
3. 使用模擬器或實機 Build & Run；或以 SwiftUI #Preview 快速預覽。
4. 訂閱徽章狀態由 @AppStorage("isSubscribed") 控制，可在 App 內點擊切換以測試 UI。
