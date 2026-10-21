import SwiftUI

@main
struct VicePulseApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark) // 默认沉浸式暗黑杂志风格
        }
    }
}
