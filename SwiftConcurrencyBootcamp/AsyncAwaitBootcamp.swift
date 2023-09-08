//  AsyncAwaitBootcamp.swift

import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.dataArray.append("Title1 : \(Thread.current)")
        }
    }
    
    func addTitle2() {
        // Runs on the Background Thread and appends on the Main Thread
        DispatchQueue.global().asyncAfter(deadline: .now() + 2){
            let title = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                
                // This append happens on the Main Thread (because we switched above)
                let title3 = "Title3 : \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
        // Runs on the Main Thread and appends
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//            self.dataArray.append("Title1 : \(Thread.current)")
//        }
    }
    
    func addAuthor1() async {
        let author1 = "Author1: \(Thread.current)"
        self.dataArray.append(author1)
        
        // The sleep() runs always on the Background Thread
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // So whatever follows will run on the Background Thread as well
        let author2 = "Author2: \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(author2)
            
            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        })
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1 = "Something1: \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(something1)
            
            let something2 = "Something2: \(Thread.current)"
            self.dataArray.append(something2)
        })
    }
}

struct AsyncAwaitBootcamp: View {
    
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
//            viewModel.addTitle1()
//            viewModel.addTitle2()
            Task {
                await viewModel.addAuthor1()
                await viewModel.addSomething()
                
                // These lines below will run AFTER the await lines above complete
                let finalText = "FINAL TEXT : \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
        }
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
    }
}
