//
//  AuthorPhotosView.swift
//  AuthorSearch
//
//

// Scrollable photo gallery for author photos with option for user to upload photos

/* References
 Stack Overflow. (2023, January 22). How to open PhotosPicker from confirmationDialog in SwiftUI? Stack Overflow. https://stackoverflow.com/questions/75201910/how-to-open-photospicker-from-confirmationdialog-in-swiftui
*/

import SwiftUI
import SwiftData

struct AuthorPhotosView: View {
    let author: Author
    
    @Query private var allUserPhotos: [UserPhoto]
    @Environment(\.modelContext) private var modelContext
    
    @State private var showImageSourceDialog = false
    @State private var showImagePicker = false
    @State private var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage = UIImage()
    
    private let photoSize: CGFloat = 220
    
    // Filter photos for this author
    private var userPhotos: [UserPhoto] {
        allUserPhotos.filter { $0.authorKey == author.key }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Photos")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // API photos with loading placeholders
                    ForEach(author.photoURLs, id: \.absoluteString) { url in
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                // Placeholder square
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: photoSize, height: photoSize)
                                    .overlay(
                                        ProgressView()
                                    )
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: photoSize, height: photoSize)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .failure:
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: photoSize, height: photoSize)
                                    .overlay(
                                        Image(systemName: "photo.badge.exclamationmark")
                                            .foregroundColor(.secondary)
                                    )
                            default:
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: photoSize, height: photoSize)
                            }
                        }
                    }
                    
                    // User-added photos from SwiftData
                    ForEach(userPhotos) { photo in
                        if let uiImage = UIImage(data: photo.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: photoSize, height: photoSize)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    // Plus button to add photo
                    Button {
                        showImageSourceDialog = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 22, weight: .bold))
                            Text("Add photo")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: photoSize, height: photoSize)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.15))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 1.5)
                        )
                    }
                }
            }
        }
        .confirmationDialog("Add Photo", isPresented: $showImageSourceDialog) {
            Button("Take Photo") {
                pickerSourceType = .camera
                showImagePicker = true
            }
            Button("Choose from Library") {
                pickerSourceType = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: pickerSourceType, selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { oldValue, newValue in
            if newValue.size.width > 0 {
                if let imageData = newValue.jpegData(compressionQuality: 0.8) {
                    let photo = UserPhoto(authorKey: author.key, imageData: imageData)
                    modelContext.insert(photo)
                }
                selectedImage = UIImage()
            }
        }
    }
}
