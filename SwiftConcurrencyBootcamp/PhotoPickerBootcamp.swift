//  PhotoPickerBootcamp.swift

import SwiftUI
import PhotosUI

@MainActor final class PhotoPickerBootcampViewModel: ObservableObject {
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    @Published private(set) var selectedImages: [UIImage] = []
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            setImages(from: imageSelections)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
//            if let data = try? await selection.loadTransferable(type: Data.self) {
//                if let uiImage = UIImage(data: data) {
//                    selectedImage = uiImage
//                    return
//                }
//            }
            
            // Same as above but with error handling
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                
                guard let data, let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                
                selectedImage = uiImage
            } catch {
                print(error)
            }
        }
    }
    
    private func setImages(from selections: [PhotosPickerItem]) {
        
        Task {
            var images: [UIImage] = []
            for selection in selections {
                if let data = try? await selection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                }
            }
            selectedImages = images
        }
    }
}

struct PhotoPickerBootcamp: View {
    
    @StateObject private var viewModel = PhotoPickerBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10 )
            }
            
            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                Text("Open the Photo Picker!")
                    .foregroundColor(.red)
            }
            
            if !viewModel.selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10 )
                        }
                    }
                }
            }
            
            PhotosPicker(selection: $viewModel.imageSelections, matching: .images) {
                Text("Open the Photos Picker!")
                    .foregroundColor(.red)
            }
        }
    }
}

struct PhotoPickerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerBootcamp()
    }
}
