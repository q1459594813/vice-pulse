import Foundation
import SwiftUI
import Combine
import CoreHaptics

@MainActor
class CountdownViewModel: ObservableObject {
    // 目标发售日期：2026 年 11 月 19 日
    @Published var targetDate: Date
    @Published var days: Int = 0
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    // 灵动岛开关与状态
    @AppStorage("isDynamicIslandEnabled") var isDynamicIslandEnabled: Bool = true
    @AppStorage("isSmartWakeEnabled") var isSmartWakeEnabled: Bool = true
    
    private var timer: AnyCancellable?
    private var hapticEngine: CHHapticEngine?

    init() {
        var components = DateComponents()
        components.year = 2026
        components.month = 11
        components.day = 19
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(identifier: "America/New_York") ?? .current
        self.targetDate = Calendar.current.date(from: components) ?? Date()

        prepareHaptics()
        calculateTime()
        startTimer()
    }

    private func startTimer() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.calculateTime()
            }
    }

    private func calculateTime() {
        let now = Date()
        let diff = targetDate.timeIntervalSince(now)

        if diff > 0 {
            let totalSeconds = Int(diff)
            days = totalSeconds / 86400
            hours = (totalSeconds % 86400) / 3600
            minutes = (totalSeconds % 3600) / 60
            seconds = totalSeconds % 60
        } else {
            days = 0
            hours = 0
            minutes = 0
            seconds = 0
        }
    }

    // 触感反馈
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Haptics Error: \(error.localizedDescription)")
        }
    }

    func triggerLightHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func triggerSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
