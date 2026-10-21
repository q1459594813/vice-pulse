import Foundation
import ActivityKit

/// 灵动岛 (Dynamic Island) 与锁屏实时活动 (Live Activities) 属性
struct ViceActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // 动态状态（倒计时与最新快报）
        public var daysRemaining: Int
        public var hoursRemaining: Int
        public var latestAlertTitle: String?
        public var alertType: AlertType?

        public init(
            daysRemaining: Int,
            hoursRemaining: Int,
            latestAlertTitle: String? = nil,
            alertType: AlertType? = nil
        ) {
            self.daysRemaining = daysRemaining
            self.hoursRemaining = hoursRemaining
            self.latestAlertTitle = latestAlertTitle
            self.alertType = alertType
        }
    }

    public enum AlertType: String, Codable, Hashable {
        case official = "官方公告"
        case offlineMarketing = "线下实景"
    }

    // 静态属性
    public var targetDate: Date
    public var targetTitle: String

    public init(targetDate: Date, targetTitle: String = "Grand Theft Auto VI") {
        self.targetDate = targetDate
        self.targetTitle = targetTitle
    }
}
