import SwiftUI

/// 完整偏好设置：包含腾讯云后端、自定义第三方 AI API、灵动岛与推送白名单
struct SettingsView: View {
    @ObservedObject var countdownVM: CountdownViewModel
    @ObservedObject var digestVM: DigestViewModel
    @State private var showingSavedAlert = false
    @State private var alertMessage = "配置已保存至本地安全存储。"

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // 报头
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PREFERENCES & ENGINES")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .tracking(2)
                            .foregroundColor(Color(hex: "FF3366"))
                        
                        Text("系统与引擎配置")
                            .font(.system(size: 28, weight: .black, design: .serif))
                            .foregroundColor(.white)
                        
                        Text("腾讯云桥接 · 自定义大模型 · 灵动岛控制")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                    // 1. 腾讯轻量云后端桥接
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Label("腾讯轻量云后端桥接 (4C4G)", systemImage: "server.rack")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Text("80 端口直连")
                                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.15))
                                .foregroundColor(.green)
                                .clipShape(Capsule())
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("服务器公网地址 (Host / IP)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            TextField("http://你的公网IP", text: $digestVM.serverBridgeHost)
                                .font(.system(size: 12, design: .monospaced))
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(.white)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }

                        Button {
                            countdownVM.triggerLightHaptic()
                            Task {
                                await digestVM.fetchAndSynthesize()
                                alertMessage = "已成功同步云端情报！"
                                showingSavedAlert = true
                            }
                        } label: {
                            HStack {
                                if digestVM.isRefreshing {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("保存并同步云端数据")
                                        .font(.system(size: 13, weight: .bold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color(hex: "FF3366"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(18)
                    .background(Color(hex: "18181E").opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    // 2. 自定义第三方 AI 接口配置 (BYO-Key)
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Label("第三方大模型 API (自动整理与翻译)", systemImage: "cpu")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Text("DeepSeek / OpenAI")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color(hex: "FF80BF"))
                        }

                        Text("配置大模型 Key 后，系统拉取到外网英文新闻会自动提纯、深度翻译为考究中文画报。")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))

                        VStack(alignment: .leading, spacing: 6) {
                            Text("API Base URL")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            TextField("https://api.deepseek.com/v1", text: $digestVM.customApiBaseUrl)
                                .font(.system(size: 12, design: .monospaced))
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(.white)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("API Key (仅保存在本地设备 Keychain)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            SecureField("sk-...", text: $digestVM.customApiKey)
                                .font(.system(size: 12, design: .monospaced))
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("模型 ID (Model Name)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            TextField("deepseek-chat", text: $digestVM.customModelName)
                                .font(.system(size: 12, design: .monospaced))
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(.white)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }

                        Button {
                            countdownVM.triggerSuccessHaptic()
                            alertMessage = "AI 接口配置已保存！拉取情报时将自动进行深度提炼与中文翻译。"
                            showingSavedAlert = true
                        } label: {
                            Text("保存 AI 接口配置")
                                .font(.system(size: 13, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.12))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(18)
                    .background(Color(hex: "18181E").opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    // 3. 灵动岛与锁屏实时活动
                    VStack(alignment: .leading, spacing: 14) {
                        Label("灵动岛与锁屏实时活动", systemImage: "circle.circle.fill")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)

                        Toggle(isOn: $countdownVM.isDynamicIslandEnabled) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("常驻灵动岛倒计时")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("关闭后顶部打孔屏恢复默认外观")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                        .tint(Color(hex: "FF3366"))

                        Divider().background(Color.white.opacity(0.08))

                        Toggle(isOn: $countdownVM.isSmartWakeEnabled) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("突发大事时自动唤醒")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("检测到重大线下营销/官方公告时亮起 1 小时")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                        .tint(Color(hex: "FF3366"))
                    }
                    .padding(18)
                    .background(Color(hex: "18181E").opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    // 4. AI 弹窗推送白名单
                    VStack(alignment: .leading, spacing: 14) {
                        Label("AI 弹窗推送白名单", systemImage: "bell.badge.fill")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)

                        Toggle(isOn: $digestVM.pushNotifyOfflineMarketing) {
                            Text("🎨 线下实景营销 (巨幅海报/3D大屏/封闭街区)")
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                        }
                        .tint(Color(hex: "FF3366"))

                        Toggle(isOn: $digestVM.pushNotifyOfficialNews) {
                            Text("⚡️ 官方直发新闻 (预告片2/发售定档/预购)")
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                        }
                        .tint(Color(hex: "FF3366"))
                    }
                    .padding(18)
                    .background(Color(hex: "18181E").opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(Color(hex: "09090C").ignoresSafeArea())
            .alert("提示", isPresented: $showingSavedAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}
