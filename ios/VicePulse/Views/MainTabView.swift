import SwiftUI

/// 原生底部 Tab 导航结构
struct MainTabView: View {
    @StateObject private var countdownVM = CountdownViewModel()
    @StateObject private var digestVM = DigestViewModel()

    init() {
        // 设置原生 iOS TabBar 半透明黑色磨砂风格
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(Color(hex: "09090C").opacity(0.85))
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            LookbookView(countdownVM: countdownVM, digestVM: digestVM)
                .tabItem {
                    Label("画报焦点", systemImage: "flame.fill")
                }

            DigestView(digestVM: digestVM)
                .tabItem {
                    Label("每日内参", systemImage: "newspaper.fill")
                }

            SettingsView(countdownVM: countdownVM, digestVM: digestVM)
                .tabItem {
                    Label("偏好与雷达", systemImage: "gearshape.fill")
                }
        }
        .tint(Color(hex: "FF3366"))
    }
}
