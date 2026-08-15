//
//  NetworkError.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

enum NetworkError: Error {

    case invalidURL
    case invalidResponse

    case unauthorized

    case httpError(
        statusCode: Int,
        data: Data
    )

    case transport(Error)

    case decoding(Error)
}
