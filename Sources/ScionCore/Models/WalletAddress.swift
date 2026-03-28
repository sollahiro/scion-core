import Foundation

public enum Chain: String, Codable, Sendable, CaseIterable {
    case ethereum = "ethereum"
    case polygon = "polygon"
    case avalanche = "avalanche"
}

public struct WalletAddress: Identifiable, Codable, Sendable {
    public let id: UUID
    public let address: String
    public let label: String?

    public init(id: UUID = UUID(), address: String, label: String? = nil) {
        self.id = id
        self.address = address
        self.label = label
    }
}
