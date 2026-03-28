import Foundation

public struct PortfolioCalculator: Sendable {
    private let alchemyClient: AlchemyClient
    private let priceClient: PriceClient

    public init(alchemyClient: AlchemyClient, priceClient: PriceClient) {
        self.alchemyClient = alchemyClient
        self.priceClient = priceClient
    }

    /// 全ウォレット・全チェーン・全トークンのポートフォリオを計算する
    public func calculate(wallets: [WalletAddress]) async throws -> Portfolio {
        // JPYC対応チェーン
        let jpycChains: [Chain] = [.avalanche, .polygon, .ethereum]
        // USDC対応チェーン（Ethereum / Polygon / Avalanche）
        let usdcChains: [Chain] = [.ethereum, .polygon, .avalanche]

        // JPYC = 1円固定のためサーバー呼び出しは USDC のみ
        async let usdcPrice = priceClient.fetchPriceInJPY(token: .usdc)
        let usdcJPY = try await usdcPrice

        let prices: [Token: Decimal] = [
            .jpyc: 1,       // 1JPYC = 1円（固定）
            .usdc: usdcJPY, // 1USDC ≒ 1USD → ドル円レートで換算
        ]

        var balances: [Balance] = []

        try await withThrowingTaskGroup(of: [Balance].self) { group in
            for wallet in wallets {
                for chain in jpycChains {
                    group.addTask {
                        let amount = try await alchemyClient.fetchBalance(
                            walletAddress: wallet.address,
                            chain: chain,
                            token: .jpyc
                        )
                        return [Balance(
                            walletAddress: wallet.address,
                            chain: chain,
                            token: .jpyc,
                            amount: amount,
                            valueInJPY: amount  // 1JPYC = 1円
                        )]
                    }
                }
                for chain in usdcChains {
                    group.addTask {
                        let amount = try await alchemyClient.fetchBalance(
                            walletAddress: wallet.address,
                            chain: chain,
                            token: .usdc
                        )
                        let valueInJPY = amount * (prices[.usdc] ?? 0)
                        return [Balance(
                            walletAddress: wallet.address,
                            chain: chain,
                            token: .usdc,
                            amount: amount,
                            valueInJPY: valueInJPY
                        )]
                    }
                }
            }
            for try await result in group {
                balances.append(contentsOf: result)
            }
        }

        return Portfolio(balances: balances)
    }
}
