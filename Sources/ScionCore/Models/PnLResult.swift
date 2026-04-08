import Foundation

/// WAC（加重平均取得単価）方式による損益計算結果
public struct PnLResult: Sendable {
    public let token: Token
    /// 現在の保有量
    public let currentAmount: Decimal
    /// 加重平均取得単価（JPY/トークン）
    public let averageCostInJPY: Decimal
    /// 実現損益（JPY）: 売却済み分の確定損益
    public let realizedPnL: Decimal
    /// 未実現損益（JPY）: 現在保有分の含み損益
    public let unrealizedPnL: Decimal
    /// 現在評価額（JPY）
    public let currentValueInJPY: Decimal
    /// 保有コスト（JPY）= currentAmount × averageCostInJPY
    public let totalCostInJPY: Decimal

    public var totalPnL: Decimal { realizedPnL + unrealizedPnL }

    public init(
        token: Token,
        currentAmount: Decimal,
        averageCostInJPY: Decimal,
        realizedPnL: Decimal,
        unrealizedPnL: Decimal,
        currentValueInJPY: Decimal,
        totalCostInJPY: Decimal
    ) {
        self.token = token
        self.currentAmount = currentAmount
        self.averageCostInJPY = averageCostInJPY
        self.realizedPnL = realizedPnL
        self.unrealizedPnL = unrealizedPnL
        self.currentValueInJPY = currentValueInJPY
        self.totalCostInJPY = totalCostInJPY
    }
}
