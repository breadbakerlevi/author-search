//
//  DetailsView.swift
//  AuthorSearch
//
//

// View for author details tab

/* References:
 Apple. (2026). joined(separator:) . Apple Developer Documentation. https://developer.apple.com/documentation/swift/sequence/joined(separator:)-5zjyj
*/

import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var appState: AppState
    @State private var detailedAuthor: Author? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                if let author = detailedAuthor {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Details")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text(author.name)
                                .font(.largeTitle)
                            
                            // Author photos gallery
                            AuthorPhotosView(author: author)
                            
                            if author.birthDate == nil && author.deathDate == nil && author.bio == nil && author.topWork == nil && author.workCount == nil {
                                Text("No additional information available for this author.")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 4)
                            } else {
                                HStack(alignment: .top) {
                                    if let birthDate = author.birthDate {
                                        Text("Born:")
                                            .font(.headline)
                                        Text(birthDate)
                                    }
                                    if let deathDate = author.deathDate {
                                        Text("Died:")
                                            .font(.headline)
                                        Text(deathDate)
                                    }
                                }
                                if let bio = author.bio {
                                    Text("Biography:")
                                        .font(.headline)
                                    Text(bio.text)
                                }
                                if let topWork = author.topWork {
                                    Text("Top Work:")
                                        .font(.headline)
                                    Text(topWork)
                                }
                                if let workCount = author.workCount {
                                    Text("Works:")
                                        .font(.headline)
                                    Text("\(workCount)")
                                }
                                // topSubjects comes from search result
                                if let subjects = appState.selectedAuthor?.topSubjects {
                                    Text("Top Subjects:")
                                        .font(.headline)
                                    Text(subjects.joined(separator: ", "))
                                }
                            }
                        }
                        .padding()
                    }
                } else if isLoading {
                    ProgressView("Loading details...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.secondary)
                } else {
                    Text("Select an author to view details")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Author Details")
            .task(id: appState.selectedAuthor?.key) {
                if let author = appState.selectedAuthor {
                    await fetchDetails(for: author)
                } else {
                    detailedAuthor = nil
                }
            }
        }
    }
    
    private func fetchDetails(for author: SearchAuthors) async {
        isLoading = true
        do {
            let service = AuthorService()
            detailedAuthor = try await service.fetchAuthorDetails(key: author.key)
        } catch {
            errorMessage = "Could not load author details."
            detailedAuthor = nil
        }
        isLoading = false
    }
}

#Preview {
    DetailsView()
        .environmentObject(AppState())
}
