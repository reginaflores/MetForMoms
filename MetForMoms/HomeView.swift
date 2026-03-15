import SwiftUI

struct HomeView: View {
    let categories = [
        ("Animals", "hare.fill", "animals"),
        ("Colors", "paintpalette.fill", "painting color"),
        ("Nature", "leaf.fill", "landscape nature"),
        ("People", "figure.2.arms.open", "portrait"),
        ("Castles", "crown.fill", "castle medieval"),
        ("Mythology", "star.fill", "mythology gods"),
        ("Egypt", "pyramid.fill", "egyptian ancient egypt"),
        ("Greece", "building.columns.fill", "greek ancient greece"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Met-style header
                    VStack(spacing: 6) {
                        // App title
                        HStack(spacing: 0) {
                            Text("The")
                                .font(.system(size: 32, weight: .regular, design: .serif))
                            Text(" Met")
                                .font(.system(size: 32, weight: .bold, design: .serif))
                            Text(" for Moms")
                                .font(.system(size: 32, weight: .bold, design: .serif))
                        }
                        .foregroundStyle(.white)

                        Text("Explore art with your little ones")
                            .font(.system(size: 15, weight: .regular, design: .serif))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.top, 2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                    .padding(.bottom, 28)
                    .background(Color.metRed)

                    // Category grid
                    VStack(spacing: 16) {
                        Text("Choose a topic")
                            .font(.system(size: 13, weight: .semibold, design: .serif))
                            .textCase(.uppercase)
                            .tracking(1.5)
                            .foregroundStyle(.secondary)
                            .padding(.top, 24)

                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 14),
                            GridItem(.flexible(), spacing: 14)
                        ], spacing: 14) {
                            ForEach(categories, id: \.0) { name, icon, query in
                                NavigationLink {
                                    ArtworkListView(category: name, query: query)
                                } label: {
                                    CategoryCard(name: name, icon: icon)
                                }
                            }
                        }
                        .padding(.horizontal)

                        NavigationLink {
                            SearchView()
                        } label: {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Search the collection")
                                    .font(.system(.headline, design: .serif))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.metRed)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)
                        .padding(.top, 6)

                        // Footer
                        VStack(spacing: 4) {
                            Text("Powered by The Metropolitan Museum of Art Open Access API")
                            Text("ReginFlores.ai")
                        }
                        .font(.system(size: 11, design: .serif))
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 12)
                        .padding(.bottom, 32)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(Color(.systemGroupedBackground))
            .toolbarBackground(Color.metRed, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct CategoryCard: View {
    let name: String
    let icon: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(Color.metRed)
            Text(name)
                .font(.system(.headline, design: .serif))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }
}

#Preview {
    HomeView()
}
