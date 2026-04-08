import Foundation

/// WAC（加重平均取得単価）方式で損益を計算する
public struct PnLCalculator: Sendable {
    public init() {}

    /// 指定トークンの損益を計算する
    /// - Parameters:
    ///   - transactions: 対象ウォレット・チェーンのトランザクション履歴（複数ウォレット可）
    ///   - currentPriceInJPY: 現在のトークン価格（JPY）
    ///   - token: 対象トークン
    public func calculate(
        transactions: [Transaction],
        currentPriceInJPY: Decimal,
        token: Token
    ) -> PnLResult {
        let sorted = transactions
            .filter { $0.token == token }
            .sorted { $0.timestamp < $1.timestamp }

        var holdingAmount: Decimal = 0
        var avgCostInJPY: Decimal = 0
        var realizedPnL: Decimal = 0

        for tx in sorted {
            switch tx.type {
            case .receive:
                let prevTotalCost = holdingAmount * avgCostInJPY
                let newTotalCost = prevTotalCost + tx.amount * tx.priceInJPY
                holdingAmount += tx.amount
                avgCostInJPY = holdingAmount > 0 ? newTotalCost / holdingAmount : 0

            case .send:
                // 実現損益 = 送信量 × (売却時単価 - 平均取得単価)
                realizedPnL += tx.amount * (tx.priceInJPY - avgCostInJPY)
                holdingAmount = max(0, holdingAmount - tx.amount)
                // avgCostInJPY は変わらない
            }
        }

        let currentValueInJPY = holdingAmount * currentPriceInJPY
        let totalCostInJPY = holdingAmount * avgCostInJPY
        let unrealizedPnL = currentValueInJPY - totalCostInJPY

        return PnLResult(
            token: token,
            currentAmount: holdingAmount,
            averageCostInJPY: avgCostInJPY,
            realizedPnL: realizedPnL,
            unrealizedPnL: unrealizedPnL,
            currentValueInJPY: currentValueInJPY,
            totalCostInJPY: totalCostInJPY
        )
    }

    /// 全トークンの損益をまとめて計算する
    public func calculateAll(
        transactions: [Transaction],
        pricesInJPY: [Token: Decimal]
    ) -> [Token: PnLResult] {
        var results: [Token: PnLResult] = [:]
        for token in Token.allCases {
            let price = pricesInJPY[token] ?? 0
            results[token] = calculate(
                transactions: transactions,
                currentPriceInJPY: price,
                token: token
            )
        }
        return results
    }
}
