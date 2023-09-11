//  StrongSelfBootcamp.swift

import SwiftUI

final class StrongSelfDataService {
    func getData() async -> String {
        "Updated data!"
    }
}

final class StrongSelfBootcampViewModel: ObservableObject {
 
    @Published var data: String = "Some title!"
    let dataService = StrongSelfDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        
        myTasks.forEach ({ $0.cancel() })
        myTasks = []
    }
    
    // This implies a strong reference (even if we didn't need to call self.data)
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    // This is a strong reference (but exact same function as above)
    func updateData2() {
        Task {
            self.data = await dataService.getData()
        }
    }
    
    // This is a strong reference (but exact same function as above)
    func updateData3() {
        Task { [self] in
            self.data = await dataService.getData()
        }
    }
    
    // This is a weak reference
    func updateDate4() {
        Task { [weak self] in
            if let data = await self?.dataService.getData(){
                self?.data = data
            }
        }
    }
    
    // We don't need to manage weak or strong reference
    // because we can manage the Task iteslf.
    func updateData5() {
        someTask = Task {
            self.data = await dataService.getData()
        }
    }
    
    func updateData6() {
        let task1 = Task {
            self.data = await dataService.getData()
        }
        myTasks.append(task1)
        
        let task2 = Task {
            self.data = await dataService.getData()
        }
        myTasks.append(task2)
    }
    
    // We purposely do NOT cancel Tasks to keep strong references
    func updateData7() {
        Task {
            self.data = await dataService.getData()
        }
        Task.detached {
            self.data = await self.dataService.getData()
        }
    }
    
}

struct StrongSelfBootcamp: View {
    
    @StateObject private var viewModel = StrongSelfBootcampViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
    }
}

struct StrongSelfBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StrongSelfBootcamp()
    }
}
