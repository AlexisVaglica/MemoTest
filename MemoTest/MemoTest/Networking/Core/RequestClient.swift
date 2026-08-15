//
//  RequestClient.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

protocol RequestClient: Sendable {
    func send<Response: Decodable>(
        _ request: APIRequest<Response>
    ) async throws -> Response
}
