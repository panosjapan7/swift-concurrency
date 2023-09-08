//  TaskBootcamp.swift

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5000000000)
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("IMAGE RETURNED SUCCESSFULLY!")
            })
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME1"){
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
        /*
        .onAppear {
            fetchImageTask = Task {
//                print(Thread())
//                print(Task.currentPriority)
                await viewModel.fetchImage()
            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
            
            
//            Task(priority: .high) {
////                try? await Task.sleep(nanoseconds: 2000000000)
//                await Task.yield()
//                print("HIGH : \(Thread()) : \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("USERINITIATED : \(Thread()) : \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("MEDIUM : \(Thread()) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .low) {
//                print("LOW : \(Thread()) : \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("UTILITY : \(Thread()) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .background) {
//                print("BACKGROUND : \(Thread()) : \(Task.currentPriority)")
//            }
            
            
//            Task(priority: .userInitiated) {
//                print("USERINITIATED : \(Thread()) : \(Task.currentPriority)")
//            }
            
            
        }
         */
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
