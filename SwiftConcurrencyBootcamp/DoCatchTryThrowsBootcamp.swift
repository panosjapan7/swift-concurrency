//  DoCatchTryThrowsBootcamp.swift

import SwiftUI

// do-catch
// try
// throws

class DoCatchTryThrowsBootcampDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT", nil)
        }
        else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT!!")
        }
        else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String {
//        if isActive {
//            return "NEW TEXT!!!"
//        }
//        else {
            throw URLError(.backgroundSessionRequiresSharedContainer)
//        }
        
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT!!!!"
        }
        else {
            throw URLError(.backgroundSessionRequiresSharedContainer)
        }
        
    }
    
}

class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        
        if let newTitle = returnedValue.title {
            self.text = newTitle
        }
        else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
        
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        
//        let newTitle = try? manager.getTitle3()
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
        
        do {
            // even though the getTitle3() is throwing an error,
            // we're not going to the catch block.
            // We move downwards and run the try manager.getTitle4() block.
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }

            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
    }
}


struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoCatchTryThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsBootcamp()
    }
}
