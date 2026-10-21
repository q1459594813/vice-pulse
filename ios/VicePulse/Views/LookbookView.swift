import SwiftUI

/// 杂志画报焦点主页
struct LookbookView: View {
    @ObservedObject var countdownVM: CountdownViewModel
    @ObservedObject var digestVM: DigestViewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // 报头 Masthead
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("VOL. 06 · ISSUE 24")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .tracking(2)
                                .foregroundColor(Color(hex: "FF3366"))
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 6, height: 6)
                                Text("RADAR LIVE")
                                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        
                        Text("VICE CHRONICLE")
                            .font(.system(size: 32, weight: .black, design: .serif))
                            .foregroundColor(.white)
                        
                        Text("官方动作 · 线下实景目击 · 倒数特刊")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    .padding(.top, 8)

                    // 核心倒计时卡片
                    CountdownCard(viewModel: countdownVM)

                    // 线下实景目击雷达栏目
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Label("线下实景目击", systemImage: "mappin.and.ellipse")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("AI 视觉验真")
                                .font(.system(size: 10, weight: .semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color(hex: "FF3366").opacity(0.15))
                                .foregroundColor(Color(hex: "FF80BF"))
                                .clipShape(Capsule())
                        }

                        ForEach(digestVM.sightings) { sighting in
                            SightingRowView(sighting: sighting)
                        }
                    }

                    // 官方动态研报
                    VStack(alignment: .leading, spacing: 14) {
                        Label("官方动态与技术研报", systemImage: "bolt.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        if let featured = digestVM.articles.first {
                            FeaturedArticleCard(article: featured)
                        }
                    }

                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(Color(hex: "09090C").ignoresSafeArea())
            .refreshable {
                countdownVM.triggerLightHaptic()
                await digestVM.fetchAndSynthesize()
            }
        }
    }
}

struct SightingRowView: View {
    let sighting: Sighting

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(sighting.location)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "FF80BF"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Capsule())

                Spacer()

                Text("来源: \(sighting.sourcePlatform)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white.opacity(0.4))
            }

            Text(sighting.title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

            Text(sighting.summary)
                .font(.system(size: 12))
                .lineSpacing(3)
                .foregroundColor(.white.opacity(0.65))

            HStack {
                Text("AI 验真评分：\(sighting.confidenceScore)%")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(.green.opacity(0.9))

                Spacer()

                Button("查看现场原图 →") {}
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "FF3366"))
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color(hex: "18181E").opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

struct FeaturedArticleCard: View {
    let article: EditorialArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("● \(article.tag)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.orange.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Spacer()

                Text("提纯 \(article.sourceCount) 篇社区源")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white.opacity(0.4))
            }

            Text(article.title)
                .font(.system(size: 16, weight: .bold, design: .serif))
                .foregroundColor(.white)

            Text(article.excerpt)
                .font(.system(size: 13))
                .lineSpacing(3)
                .foregroundColor(.white.opacity(0.7))

            if let quote = article.quote {
                Text("“\(quote)”")
                    .font(.system(size: 12, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(Color(hex: "FF80BF"))
                    .padding(.leading, 8)
                    .overlay(
                        Rectangle()
                            .fill(Color(hex: "FF3366"))
                            .frame(width: 2),
                        alignment: .leading
                    )
            }
        }
        .padding(18)
        .background(Color(hex: "18181E").opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
