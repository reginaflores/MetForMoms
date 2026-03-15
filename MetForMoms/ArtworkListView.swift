import SwiftUI

struct ArtworkListView: View {
    let category: String
    let query: String

    @State private var artworks: [Artwork] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Finding art...")
                    .font(.title3)
            } else if let error = errorMessage {
                ContentUnavailableView("Oops!", systemImage: "exclamationmark.triangle", description: Text(error))
            } else if artworks.isEmpty {
                ContentUnavailableView("No art found", systemImage: "photo.on.rectangle.angled", description: Text("Try a different category!"))
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
        .navigationTitle(category)
        .task {
            await loadArtworks()
        }
    }

    private func loadArtworks() async {
        do {
            let ids = try await MetAPI.shared.search(query: query)
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
            isLoading = false
        } catch {
            errorMessage = "Couldn't load artworks. Check your connection!"
            isLoading = false
        }
    }
}

struct ArtworkRow: View {
    let artwork: Artwork

    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: artwork.primaryImageSmall)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(.systemGray5)
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.primary)

                if !artwork.artistDisplayName.isEmpty {
                    Text(artwork.artistDisplayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                if !artwork.objectDate.isEmpty {
                    Text(artwork.objectDate)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        ArtworkListView(category: "Animals", query: "animals")
    }
}
