import SwiftUI

/// 每日内参流视图
struct DigestView: View {
    @ObservedObject var digestVM: DigestViewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // 顶栏说明
                    VStack(alignment: .leading, spacing: 4) {
                        Text("EDITORIAL STREAM")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .tracking(2)
                            .foregroundColor(Color(hex: "FF3366"))
                        
                        Text("每日情报内参")
                            .font(.system(size: 28, weight: .black, design: .serif))
                            .foregroundColor(.white)
                        
                        Text("已过滤所有同质灌水与造谣，只留高可信精髓")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                    // 状态与手动刷新卡片
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(digestVM.isSynthesizingWithAI ? Color.purple : Color.green)
                                    .frame(width: 6, height: 6)
                                Text(digestVM.isSynthesizingWithAI ? "AI 深度翻译整理中" : "云端情报流就绪")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            Text(digestVM.statusMessage)
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.5))
                                .lineLimit(1)
                        }

                        Spacer()

                        Button {
                            Task {
                                await digestVM.fetchAndSynthesize()
                            }
                        } label: {
                            HStack(spacing: 4) {
                                if digestVM.isRefreshing || digestVM.isSynthesizingWithAI {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("✨ AI提纯最新")
                                        .font(.system(size: 11, weight: .bold))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "FF3366"), Color(hex: "8B5CF6")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(14)
                    .background(Color(hex: "18181E").opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // 专栏文章流
                    ForEach(digestVM.articles) { article in
                        DigestArticleRow(article: article)
                    }

                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(Color(hex: "09090C").ignoresSafeArea())
        }
    }
}

struct DigestArticleRow: View {
    let article: EditorialArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(article.tag)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "FF80BF"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: "FF3366").opacity(0.12))
                    .clipShape(Capsule())

                Spacer()

                Text(article.publishedAt, style: .date)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white.opacity(0.35))
            }

            Text(article.title)
                .font(.system(size: 16, weight: .bold, design: .serif))
                .foregroundColor(.white)

            Text(article.content)
                .font(.system(size: 12))
                .lineSpacing(4)
                .foregroundColor(.white.opacity(0.7))

            if let quote = article.quote {
                VStack(alignment: .leading, spacing: 4) {
                    Text("主编评注：")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                    Text(quote)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color.black.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(18)
        .background(Color(hex: "18181E").opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
