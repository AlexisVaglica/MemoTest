//
//  ImageCaptureRepository.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import UIKit
import Kingfisher

protocol ImageCaptureRepository: Sendable {
    func getImages(URLs: [URL]) async throws
}

final class ImageCaptureService: ImageCaptureRepository {
    func getImages(URLs: [URL]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
                  for url in URLs {
                      group.addTask {
                          try Task.checkCancellation()
                          _ = try await KingfisherManager.shared.retrieveImage(
                              with: url,
                              options: nil,
                              progressBlock: nil
                          )
                      }
                  }

                  try await group.waitForAll()
              }
    }
}
