//
//  SearchView.swift
//  AuthorSearch
//
//

// View for search tab

import SwiftUI

struct SearchView: View {
    @StateObject var searchContext = SearchContext()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            Group {
                if searchContext.query.isEmpty {
                    VStack {
                        Spacer()
                        Text("Search for an author to view results")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else if searchContext.isLoading {
                    ProgressView("Searching...")
                } else if searchContext.authors.isEmpty && !searchContext.debouncedQuery.isEmpty {
                    Text("No authors found")
                        .foregroundColor(.secondary)
                } else {
                    List(searchContext.authors) { author in
                        Button {
                            appState.selectedAuthor = author
                            appState.selectedTab = 1
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(author.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                if let birthDate = author.birthDate {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.secondary)
                                        Text("Born: \(birthDate)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                if let topWork = author.topWork {
                                    HStack {
                                        Image(systemName: "book.fill")
                                            .foregroundColor(.brown)
                                        Text(topWork)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                                
                                if let workCount = author.workCount {
                                    HStack {
                                        Image(systemName: "books.vertical.fill")
                                            .foregroundColor(.orange)
                                        Text("\(workCount) works")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .searchable(text: $searchContext.query)
            .onChange(of: searchContext.debouncedQuery) { oldValue, newValue in
                searchContext.performSearch(query: newValue)
            }
            .navigationTitle("Author Search")
        }
    }
}

#Preview {
    SearchView()
}
