import SwiftUI

struct ArtworkDetailView: View {
    let artwork: Artwork

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: artwork.primaryImageSmall)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color(.systemGray5)
                        .frame(height: 300)
                        .overlay {
                            ProgressView()
                        }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                VStack(spacing: 12) {
                    Text(artwork.title)
                        .font(.system(.title2, design: .serif).bold())
                        .multilineTextAlignment(.center)

                    if !artwork.artistDisplayName.isEmpty {
                        Text("By \(artwork.artistDisplayName)")
                            .font(.system(.title3, design: .serif))
                            .foregroundStyle(.secondary)
                    }

                    if !artwork.objectDate.isEmpty {
                        Label(artwork.objectDate, systemImage: "calendar")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    if !artwork.department.isEmpty {
                        Label(artwork.department, systemImage: "building.2")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    if !artwork.medium.isEmpty {
                        VStack(spacing: 4) {
                            Text("Made with")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                            Text(artwork.medium)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.horizontal)

                // Fun fact section for kids
                FunFactCard(artwork: artwork)
                    .padding(.horizontal)
            }
            .padding(.bottom, 32)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FunFactCard: View {
    let artwork: Artwork

    var body: some View {
        VStack(spacing: 8) {
            Label("Talk About It!", systemImage: "bubble.left.and.bubble.right.fill")
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Color.metRed)

            Text(conversationStarter)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    var conversationStarter: String {
        let starters = [
            "What colors do you see in this artwork?",
            "How does this artwork make you feel?",
            "What story do you think this artwork is telling?",
            "If you could step inside this artwork, what would you do?",
            "What sounds do you think you'd hear in this scene?",
            "Would you hang this in your room? Why or why not?",
        ]
        let index = abs(artwork.objectID) % starters.count
        return starters[index]
    }
}

#Preview {
    NavigationStack {
        ArtworkDetailView(artwork: Artwork(
            objectID: 1,
            title: "Starry Night",
            artistDisplayName: "Vincent van Gogh",
            objectDate: "1889",
            primaryImageSmall: "",
            department: "European Paintings",
            medium: "Oil on canvas",
            objectURL: ""
        ))
    }
}
