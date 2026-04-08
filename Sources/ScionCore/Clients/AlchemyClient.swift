import Foundation

public struct AlchemyClient: Sendable {
    private let baseURL: URL
    private let session: URLSession

    /// - Parameter baseURL: VaporサーバーのエンドポイントURL（APIキーはサーバー側で管理）
    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    /// 指定チェーン・ウォレットのトークン残高を取得する
    public func fetchBalance(
        walletAddress: String,
        chain: Chain,
        token: Token
    ) async throws -> Decimal {
        var components = URLComponents(url: baseURL.appendingPathComponent("/balances"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "address", value: walletAddress),
            URLQueryItem(name: "chain", value: chain.rawValue),
            URLQueryItem(name: "token", value: token.rawValue),
        ]
        guard let url = components.url else {
            throw AlchemyClientError.invalidURL
        }
        let (data, response) = try await session.data(from: url)
        try validate(response: response)
        let result = try JSONDecoder().decode(BalanceResponse.self, from: data)
        return result.amount
    }

    /// 指定チェーン・ウォレットのトランザクション履歴を取得する
    public func fetchTransactions(
        walletAddress: String,
        chain: Chain,
        token: Token
    ) async throws -> [Transaction] {
        var components = URLComponents(url: baseURL.appendingPathComponent("/transactions"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "address", value: walletAddress),
            URLQueryItem(name: "chain", value: chain.rawValue),
            URLQueryItem(name: "token", value: token.rawValue),
        ]
        guard let url = components.url else {
            throw AlchemyClientError.invalidURL
        }
        let (data, response) = try await session.data(from: url)
        try validate(response: response)
        let results = try JSONDecoder().decode([TransactionResponse].self, from: data)
        return results.map { $0.toDomain(chain: chain, token: token) }
    }

    private func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw AlchemyClientError.serverError
        }
    }
}

public enum AlchemyClientError: Error, Sendable {
    case invalidURL
    case serverError
}

// MARK: - Response DTOs

private struct BalanceResponse: Decodable {
    let amount: Decimal
}

private struct TransactionResponse: Decodable {
    let hash: String
    let type: String
    let amount: Decimal
    let fromAddress: String
    let toAddress: String
    let timestamp: Date
    let blockNumber: Int
    let priceInJPY: Decimal

    func toDomain(chain: Chain, token: Token) -> Transaction {
        Transaction(
            id: hash,
            chain: chain,
            token: token,
            type: type == "send" ? .send : .receive,
            amount: amount,
            fromAddress: fromAddress,
            toAddress: toAddress,
            timestamp: timestamp,
            blockNumber: blockNumber,
            priceInJPY: priceInJPY
        )
    }
}
