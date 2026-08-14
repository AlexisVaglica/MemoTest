//
//  URLSessionClient.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

final class URLSessionClient: RequestClient {

    private let baseURL: URL
    private let session: URLSession
    private let token: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMTc3ZjBkNTQ3MGJiZmE5MWRlZDhkM2YxYzU5MThlYSIsIm5iZiI6MTcxNjMxNzI3MC4wMTIsInN1YiI6IjY2NGNlYzU2ZmI1NTM5NGI4OGNkZDQ0ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ERDd5fjodxlanvhp8tLvkCWeCobz7Gu82vEu0eWiMJA"

    init(
        baseURL: URL,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    func send<Response: Decodable>(
        _ request: APIRequest<Response>
    ) async throws -> Response {

        var urlRequest = try buildURLRequest(from: request)
        
        urlRequest.setValue(
                    "Bearer \(token)",
                    forHTTPHeaderField: "Authorization"
                )
        
        urlRequest.setValue(
                    "application/json",
                    forHTTPHeaderField: "Accept"
                )
        
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(
                for: urlRequest
            )

        } catch {

            throw NetworkError.transport(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        try validate(
            response: httpResponse,
            data: data
        )

        do {

            let decoder = JSONDecoder()

            return try decoder.decode(
                Response.self,
                from: data
            )

        } catch {

            throw NetworkError.decoding(error)
        }
    }
}

private extension URLSessionClient {

    func buildURLRequest<Response>(
        from request: APIRequest<Response>
    ) throws -> URLRequest {

        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(request.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        if !request.queryItems.isEmpty {
            components.queryItems = request.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = request.method.rawValue

        urlRequest.httpBody = request.body

        request.headers.forEach {
            urlRequest.setValue(
                $0.value,
                forHTTPHeaderField: $0.key
            )
        }

        return urlRequest
    }
}

private extension URLSessionClient {

    func validate(
        response: HTTPURLResponse,
        data: Data
    ) throws {

        switch response.statusCode {

        case 200...299:
            return

        case 401:
            throw NetworkError.unauthorized

        default:
            throw NetworkError.httpError(
                statusCode: response.statusCode,
                data: data
            )
        }
    }
}
