import Foundation

public struct Portfolio: Sendable {
    public let balances: [Balance]
    public let totalValueInJPY: Decimal
    public let fetchedAt: Date

    public init(balances: [Balance], fetchedAt: Date = Date()) {
        self.balances = balances
        self.totalValueInJPY = balances.reduce(Decimal.zero) { $0 + $1.valueInJPY }
        self.fetchedAt = fetchedAt
    }

    public func balances(for token: Token) -> [Balance] {
        balances.filter { $0.token == token }
    }

    public func balances(for chain: Chain) -> [Balance] {
        balances.filter { $0.chain == chain }
    }

    public func totalAmount(for token: Token) -> Decimal {
        balances(for: token).reduce(Decimal.zero) { $0 + $1.amount }
    }
}
