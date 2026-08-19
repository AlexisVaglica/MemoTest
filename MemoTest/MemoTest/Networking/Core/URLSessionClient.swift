//
//  URLSessionClient.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

actor URLSessionClient: RequestClient {
    private let baseURL: URL
    private let session: URLSession
    private let accessToken: String?

    init(
        baseURL: URL,
        session: URLSession = .shared,
        accessToken: String? = TMDBConfiguration.accessToken
    ) {
        self.baseURL = baseURL
        self.session = session
        self.accessToken = accessToken
    }

    func send<Response: Decodable>(
        _ request: APIRequest<Response>
    ) async throws -> Response {

        guard let accessToken else {
            throw NetworkError.missingAccessToken
        }

        var urlRequest = try buildURLRequest(from: request)
        
        urlRequest.setValue(
                    "Bearer \(accessToken)",
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

private struct TMDBConfiguration {
    static var accessToken: String? {
        guard
            let value = Bundle.main.object(
                forInfoDictionaryKey: "TMDBAccessToken"
            ) as? String
        else {
            return nil
        }

        let token = value.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !token.isEmpty, token != "your_tmdb_api_read_access_token" else {
            return nil
        }

        return token
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
