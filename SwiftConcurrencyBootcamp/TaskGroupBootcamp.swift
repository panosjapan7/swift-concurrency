//  TaskGroupBootcamp.swift

import SwiftUI

class TaskGroupBootcampDataManager {
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/300")
        async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/300")
        async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/300")
        async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/300")
        
        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
        
        return [image1, image2, image3, image4]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        
        let urlStrings = ["https://picsum.photos/300", "https://picsum.photos/300", "https://picsum.photos/300", "https://picsum.photos/300", "https://picsum.photos/300"]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            // we reserve only the needed amount of data we're fetching in our memory
            images.reserveCapacity(urlStrings.count)
            
            for urlString in urlStrings {
                group.addTask {
                    // we're making the try optional so that if one try fails to fetch an
                    // image, the whole process won't get an error.
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            
            // We manually add every task to the Task group
            /*
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/300")
            }
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/300")
            }
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/300")
            }
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/300")
            }
             */
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            }
            else {
                throw URLError(.badURL)
            }
        } catch  {
            throw error
        }
    }
}

class TaskGroupBootcampViewModel: ObservableObject {
    
    @Published var images: [UIImage] = []
    let manager = TaskGroupBootcampDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct TaskGroupBootcamp: View {
    
    @StateObject private var viewModel = TaskGroupBootcampViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group")
            .task {
                await viewModel.getImages()
            }
        }
    }
    
    struct TaskGroupBootcamp_Previews: PreviewProvider {
        static var previews: some View {
            TaskGroupBootcamp()
        }
    }
}
