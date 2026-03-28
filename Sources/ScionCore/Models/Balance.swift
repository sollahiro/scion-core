import Foundation

public enum Token: String, Codable, Sendable, CaseIterable {
    case jpyc = "JPYC"
    case usdc = "USDC"
}

public struct Balance: Identifiable, Sendable {
    public let id: UUID
    public let walletAddress: String
    public let chain: Chain
    public let token: Token
    /// トークン量（例: 1000.0 JPYC）
    public let amount: Decimal
    /// JPY建て評価額
    public let valueInJPY: Decimal
    public let fetchedAt: Date

    public init(
        id: UUID = UUID(),
        walletAddress: String,
        chain: Chain,
        token: Token,
        amount: Decimal,
        valueInJPY: Decimal,
        fetchedAt: Date = Date()
    ) {
        self.id = id
        self.walletAddress = walletAddress
        self.chain = chain
        self.token = token
        self.amount = amount
        self.valueInJPY = valueInJPY
        self.fetchedAt = fetchedAt
    }
}
