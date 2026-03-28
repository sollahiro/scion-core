import Foundation

/// Vaporサーバー経由でトークンのJPY建て価格を取得するクライアント。
/// - JPYC: 1JPYC = 1円（固定）
/// - USDC: 1USDC ≒ 1ドル → ドル円レートで換算
public struct PriceClient: Sendable {
    private let baseURL: URL
    private let session: URLSession

    /// - Parameter baseURL: VaporサーバーのエンドポイントURL
    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    /// トークンのJPY建て価格（円）を取得する
    public func fetchPriceInJPY(token: Token) async throws -> Decimal {
        var components = URLComponents(url: baseURL.appendingPathComponent("/prices"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "token", value: token.rawValue),
        ]
        guard let url = components.url else {
            throw PriceClientError.invalidURL
        }
        let (data, response) = try await session.data(from: url)
        try validate(response: response)
        let result = try JSONDecoder().decode(PriceResponse.self, from: data)
        return result.priceInJPY
    }

    private func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw PriceClientError.serverError
        }
    }
}

public enum PriceClientError: Error, Sendable {
    case invalidURL
    case serverError
}

private struct PriceResponse: Decodable {
    let priceInJPY: Decimal
}
