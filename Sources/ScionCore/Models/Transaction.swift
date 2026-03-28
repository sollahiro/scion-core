import Foundation

public enum TransactionType: String, Codable, Sendable {
    case send
    case receive
}

public struct Transaction: Identifiable, Sendable {
    public let id: String  // tx hash
    public let chain: Chain
    public let token: Token
    public let type: TransactionType
    public let amount: Decimal
    public let fromAddress: String
    public let toAddress: String
    public let timestamp: Date
    public let blockNumber: Int

    public init(
        id: String,
        chain: Chain,
        token: Token,
        type: TransactionType,
        amount: Decimal,
        fromAddress: String,
        toAddress: String,
        timestamp: Date,
        blockNumber: Int
    ) {
        self.id = id
        self.chain = chain
        self.token = token
        self.type = type
        self.amount = amount
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.timestamp = timestamp
        self.blockNumber = blockNumber
    }
}
