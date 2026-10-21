import SwiftUI

/// 杂志封面级倒计时卡片
struct CountdownCard: View {
    @ObservedObject var viewModel: CountdownViewModel

    var body: some View {
        VStack(spacing: 16) {
            // 顶部小标签
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color(hex: "FF3366"))
                        .frame(width: 6, height: 6)
                    Text("TARGET: NOV 19, 2026")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "FF80BF"))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.08))
                .clipShape(Capsule())

                Spacer()

                Text("LEONIDA · VICE CITY")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.4))
            }

            // 核心巨大倒计时数字
            VStack(spacing: 2) {
                Text("\(viewModel.days)")
                    .font(.system(size: 64, weight: .black, design: .serif))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
                
                Text("DAYS REMAINING")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(3)
                    .foregroundColor(Color(hex: "FF80BF"))
            }
            .padding(.vertical, 8)

            // 时 / 分 / 秒 子计数器
            HStack(spacing: 8) {
                SubCounterView(value: viewModel.hours, label: "HOURS")
                SubCounterView(value: viewModel.minutes, label: "MINS")
                SubCounterView(value: viewModel.seconds, label: "SECS", isAccent: true)
            }
        }
        .padding(20)
        .background(
            ZStack {
                // 毛玻璃背景
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(hex: "18181E").opacity(0.85))
                
                // 迈阿密粉紫晚霞光晕
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "FF3366").opacity(0.4), Color(hex: "8B5CF6").opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        )
        .shadow(color: Color(hex: "FF3366").opacity(0.15), radius: 25, x: 0, y: 10)
    }
}

struct SubCounterView: View {
    let value: Int
    let label: String
    var isAccent: Bool = false

    var body: some View {
        VStack(spacing: 2) {
            Text(String(format: "%02d", value))
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(isAccent ? Color(hex: "FF3366") : .white.opacity(0.9))
                .contentTransition(.numericText())
            
            Text(label)
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// 颜色辅助扩展
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
