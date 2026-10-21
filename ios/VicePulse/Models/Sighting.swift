import Foundation

/// 线下实景营销目击记录模型
struct Sighting: Identifiable, Codable {
    let id: UUID
    let title: String
    let location: String
    let sourcePlatform: String // Reddit, TikTok, X, Instagram
    let sourceUrl: String
    let summary: String
    let confidenceScore: Int   // AI 验真评分 0 - 100
    let timestamp: Date
    let imageUrls: [String]
    let isOfficialVerified: Bool

    init(
        id: UUID = UUID(),
        title: String,
        location: String,
        sourcePlatform: String,
        sourceUrl: String = "",
        summary: String,
        confidenceScore: Int,
        timestamp: Date = Date(),
        imageUrls: [String] = [],
        isOfficialVerified: Bool = false
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.sourcePlatform = sourcePlatform
        self.sourceUrl = sourceUrl
        self.summary = summary
        self.confidenceScore = confidenceScore
        self.timestamp = timestamp
        self.imageUrls = imageUrls
        self.isOfficialVerified = isOfficialVerified
    }
}

/// 每日内参画报特刊模型
struct EditorialArticle: Identifiable, Codable {
    let id: UUID
    let tag: String            // 如：官方直发、物理引擎、电台选曲
    let title: String
    let excerpt: String
    let quote: String?
    let content: String
    let sourceCount: Int       // AI 提纯的源文章篇数
    let publishedAt: Date
    let category: ArticleCategory

    enum ArticleCategory: String, Codable {
        case official = "官方公告"
        case offlineMarketing = "线下营销"
        case technical = "机制与技术"
        case culture = "音乐与画册"
    }
}
