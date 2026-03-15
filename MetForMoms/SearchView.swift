import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var artworks: [Artwork] = []
    @State private var isLoading = false
    @State private var hasSearched = false

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Searching the museum...")
                    .font(.title3)
            } else if hasSearched && artworks.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else if artworks.isEmpty {
                ContentUnavailableView("Search the Met", systemImage: "magnifyingglass", description: Text("Try searching for \"sunflowers\" or \"armor\""))
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(artworks) { artwork in
                            NavigationLink {
                                ArtworkDetailView(artwork: artwork)
                            } label: {
                                ArtworkRow(artwork: artwork)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Search")
        .searchable(text: $searchText, prompt: "What art do you want to find?")
        .onSubmit(of: .search) {
            Task { await search() }
        }
    }

    private func search() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isLoading = true
        artworks = []
        hasSearched = true

        do {
            let ids = try await MetAPI.shared.search(query: searchText)
            let selected = Array(ids.prefix(20))

            await withTaskGroup(of: Artwork?.self) { group in
                for id in selected {
                    group.addTask {
                        try? await MetAPI.shared.fetchArtwork(id: id)
                    }
                }
                for await artwork in group {
                    if let artwork, artwork.hasImage {
                        artworks.append(artwork)
                    }
                }
            }
        } catch {
            // Search failed silently, empty results shown
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
