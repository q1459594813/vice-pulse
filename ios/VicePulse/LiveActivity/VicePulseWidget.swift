import WidgetKit
import SwiftUI
import ActivityKit

/// 真正的灵动岛 (Dynamic Island) 与锁屏实时活动小组件
struct VicePulseWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ViceActivityAttributes.self) { context in
            // 锁屏实时活动横幅
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // 灵动岛长按展开状态 (Expanded)
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color(hex: "FF3366"))
                            .frame(width: 8, height: 8)
                        Text("GTA VI")
                            .font(.system(size: 13, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 8)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.daysRemaining) 天")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(Color(hex: "FF80BF"))
                        .padding(.trailing, 8)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        if let alert = context.state.latestAlertTitle {
                            Text(alert)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.85))
                                .lineLimit(1)
                        } else {
                            Text("发售锁定: 2026年11月19日 · 罪恶都市")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 6)
                }
            } compactLeading: {
                // 紧凑左侧图标
                HStack(spacing: 3) {
                    Circle()
                        .fill(Color(hex: "FF3366"))
                        .frame(width: 6, height: 6)
                    Text("VI")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                }
            } compactTrailing: {
                // 紧凑右侧倒计时
                Text("\(context.state.daysRemaining)d")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "FF80BF"))
            } minimal: {
                // 最小状态（有多个灵动岛时的圆点）
                Text("VI")
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(Color(hex: "FF3366"))
            }
        }
    }
}

/// 锁屏常驻大卡片
struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<ViceActivityAttributes>

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("GTA VI · 倒计时")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "FF80BF"))
                    
                    if let type = context.state.alertType {
                        Text(type.rawValue)
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color(hex: "FF3366").opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                
                Text(context.state.latestAlertTitle ?? "2026年11月19日 · 期待重聚迈阿密")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 1) {
                Text("\(context.state.daysRemaining)")
                    .font(.system(size: 26, weight: .black, design: .serif))
                    .foregroundColor(.white)
                Text("DAYS")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundColor(Color(hex: "FF80BF"))
            }
        }
        .padding(16)
        .background(Color(hex: "09090C").opacity(0.95))
    }
}
