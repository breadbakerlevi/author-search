//
//  WorksView.swift
//  AuthorSearch
//
//

// View for author's works tab with infinite scroll pagination and sorting

import SwiftUI

struct WorksView: View {
    @EnvironmentObject var appState: AppState

    @State private var works: [Work] = []
    @State private var totalWorks: Int = 0
    @State private var offset: Int = 0
    @State private var isInitialLoading = false
    @State private var isLoadingMore = false

    enum SortOption: String, CaseIterable {
        case title = "Title"
        case year = "Year"
    }

    @State private var sortOption: SortOption = .title

    var sortedWorks: [Work] {
        switch sortOption {
        case .title:
            return works.sorted { $0.title.lowercased() < $1.title.lowercased() }
        case .year:
            return works.sorted { ($0.firstPublishYear ?? 0) < ($1.firstPublishYear ?? 0) }
        }
    }

    private var hasMore: Bool {
        works.count < totalWorks
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if appState.selectedAuthor != nil {
                    Picker("Sort by", selection: $sortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    if isInitialLoading {
                        Spacer()
                        ProgressView("Loading works...")
                        Spacer()
                    } else if works.isEmpty {
                        Spacer()
                        Text("No works found")
                            .foregroundColor(.secondary)
                        Spacer()
                    } else {
                        List {
                            ForEach(sortedWorks) { work in
                                HStack {
                                    Text(work.title)
                                        .font(.headline)
                                    Spacer()
                                    if let year = work.firstPublishYear {
                                        Text(String(year))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                                .onAppear {
                                    if work.id == works.last?.id && hasMore && !isLoadingMore {
                                        Task {
                                            await loadMore()
                                        }
                                    }
                                }
                            }

                            if isLoadingMore {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)

                        Text("\(works.count) of \(totalWorks) works loaded")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 4)
                    }
                } else {
                    Spacer()
                    Text("Select an author to view works")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .navigationTitle("Works")
            .task(id: appState.selectedAuthor?.key) {
                if appState.selectedAuthor != nil {
                    await initialLoad()
                } else {
                    resetState()
                }
            }
        }
    }

    // Loading functions

    private func initialLoad() async {
        resetState()
        isInitialLoading = true
        await fetchWorks()
        isInitialLoading = false
    }

    private func loadMore() async {
        guard hasMore, !isLoadingMore else { return }
        isLoadingMore = true
        await fetchWorks()
        isLoadingMore = false
    }

    private func fetchWorks() async {
        guard let author = appState.selectedAuthor else { return }
        do {
            let service = AuthorService()
            let response = try await service.fetchAuthorWorks(key: author.key, offset: offset)
            works.append(contentsOf: response.docs)
            totalWorks = response.numFound
            offset = works.count
        } catch {
            print("Error fetching works: \(error)")
        }
    }

    private func resetState() {
        works = []
        totalWorks = 0
        offset = 0
    }
}

#Preview {
    WorksView()
        .environmentObject(AppState())
}
