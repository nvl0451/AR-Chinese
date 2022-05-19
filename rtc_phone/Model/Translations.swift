// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct TranslateData: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let text, detectedLanguageCode: String
}
