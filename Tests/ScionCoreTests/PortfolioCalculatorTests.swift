import Testing
@testable import ScionCore

@Suite("Portfolio")
struct PortfolioCalculatorTests {

    @Test("残高合計が正しく計算される")
    func totalValue() {
        let balances = [
            Balance(walletAddress: "0xABC", chain: .ethereum, token: .jpyc, amount: 1000, valueInJPY: 1000),
            Balance(walletAddress: "0xABC", chain: .polygon,  token: .jpyc, amount:  500, valueInJPY:  500),
            Balance(walletAddress: "0xABC", chain: .ethereum, token: .usdc, amount:   10, valueInJPY: 1500),
        ]
        let portfolio = Portfolio(balances: balances)
        #expect(portfolio.totalValueInJPY == 3000)
    }

    @Test("トークンでフィルタできる")
    func filterByToken() {
        let balances = [
            Balance(walletAddress: "0xABC", chain: .ethereum, token: .jpyc, amount: 1000, valueInJPY: 1000),
            Balance(walletAddress: "0xABC", chain: .ethereum, token: .usdc, amount:   10, valueInJPY: 1500),
        ]
        let portfolio = Portfolio(balances: balances)
        #expect(portfolio.balances(for: .jpyc).count == 1)
        #expect(portfolio.totalAmount(for: .jpyc) == 1000)
    }
}
