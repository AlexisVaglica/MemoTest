//
//  CardObject.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

import Foundation

struct CardObject: Identifiable, Equatable {
    let id: UUID = UUID()
    let content: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}
