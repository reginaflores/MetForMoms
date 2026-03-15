import Foundation
import SwiftUI

extension Color {
    static let metRed = Color(red: 0.894, green: 0.0, blue: 0.169)
    static let metBlack = Color(red: 0.1, green: 0.1, blue: 0.1)
}

struct SearchResult: Codable {
    let total: Int
    let objectIDs: [Int]?
}

struct Artwork: Codable, Identifiable {
    let objectID: Int
    let title: String
    let artistDisplayName: String
    let objectDate: String
    let primaryImageSmall: String
    let department: String
    let medium: String
    let objectURL: String

    var id: Int { objectID }
    var hasImage: Bool { !primaryImageSmall.isEmpty }
}

class MetAPI {
    static let shared = MetAPI()
    private let baseURL = "https://collectionapi.metmuseum.org/public/collection/v1"

    func search(query: String) async throws -> [Int] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "\(baseURL)/search?hasImages=true&q=\(encoded)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(SearchResult.self, from: data)
        return result.objectIDs ?? []
    }

    func fetchArtwork(id: Int) async throws -> Artwork {
        let url = URL(string: "\(baseURL)/objects/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Artwork.self, from: data)
    }
}
