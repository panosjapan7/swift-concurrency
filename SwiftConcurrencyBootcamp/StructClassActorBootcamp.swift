//  StructClassActorBootcamp.swift

/*
 
 Links:
  https://blog.onewayfirst.com/ios/posts/2019-03-19-class-vs-struct/
  https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language
  https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae
  https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language/59219141#59219141
  https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding
  https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845
  https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/
  https://medium.com/doyeona/automatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99
 
 VALUE TYPES:
 - Struct, Enum, String, Int, etc.
 - Stored in the Stack
 - FASTER than Reference types
 - THREAD-SAFE: Because every thread has its own stack, anything in the Stack is thread-safe by default
 - When you assign or pass a value type, you're passing a copy of the data. Not a reference to the original
    When you assign or pass a value type a new copy of the data is created.
 
 REFERENCE TYPES:
 - Class, Function, Actor
 - Store in the Heap (we have only one heap but we have one Stack per Thread)
 - Slower, but synchronized
 - NOT THREAD-SAFE by deafault
 - When you assign or pass a refence type, a new reference to original instance will be created (pointer).
 
 - - - - - - - - - - - - -
 
 STACK:
 - Stores value types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast.
 - Each Thread has its own Stack.
 
 HEAP:
 - Stores Reference types
- It is shared across Threads (each Thread doesn't have its own Heap)
 
 - - - - - - - - - - - - -
 
 STRUCT:
 - Based on VALUES
 - Can be mutated
 - Stored in the Stack
 
 CLASS:
 - Based on REFERENCES (aka INSTANCES)
 - Stored in the Heap
 - A Class can Inherit from other classes
 
 ACTOR:
 - Sames as a Class, but Thread safe.
    (which means that it needs to be in an asynchronous environment
        and await to get in and out of the Actor)
 
 - - - - - - - - - - - - -
 
 Structs: Used for Data Models, Views
 
 Class: Used for ViewModels (ObservableObject)
 
 Actor: Used for Shared 'Manager' and 'Data Store' type of classes
    (shared classes that are going to be accessed by many places in the app)
 
 
 */

import SwiftUI

actor StructClassActorBootcampDataManager {
    
    func getDataFromDatabase() {
        
    }
    
}

class StructClassActorBootcampViewModel: ObservableObject {
    
    @Published var title: String = ""
    
    init() {
        print("ViewModel INIT")
    }
    
}

struct StructClassActorBootcamp: View {
    
    @StateObject private var viewModel = StructClassActorBootcampViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue)
            .onAppear {
//                runTest()
            }
    }
}

struct StructClassActorBootcampHomeView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
    
}


struct StructClassActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp(isActive: true)
    }
}

extension StructClassActorBootcamp {
    
    private func runTest() {
        print("Test started!")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    private func printDivider() {
        print("""
              ------------------------------------------------------------------
              """)
    }
    
    private func structTest1() {
        print("structTest1()")
        let objectA = MyStruct(title: "Starting Title")
        print("ObjectA:", objectA.title)
        
        print("Pass the VALUES of ObjectA to ObjectB")
        var objectB = objectA
        print("ObjectB:", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed/")
        
        print("ObjectA:", objectA.title)
        print("ObjectB:", objectB.title)
    }
    
    private func classTest1() {
        print("classTest1()")
        let objectA = MyClass(title: "Starting title.")
        print("ObjectA:", objectA.title)
        
        print("Pass the REFERENCE of ObjectA to ObjectB")
        let objectB = objectA
        print("ObjectB:", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed/")
        
        print("ObjectA:", objectA.title)
        print("ObjectB:", objectB.title)

    }
    
    private func actorTest1() {
        // we put it in Task so that the code becomes asynchronous
        Task {
            print("actorTest1()")
            let objectA = MyActor(title: "Starting title.")
            await print("ObjectA:", objectA.title)
            
            print("Pass the REFERENCE of ObjectA to ObjectB")
            let objectB = objectA
            await print("ObjectB:", objectB.title)
            
            await objectB.updateTitle(newTitle: "Second title!")
            print("ObjectB title changed/")
            
            await print("ObjectA:", objectA.title)
            await print("ObjectB:", objectB.title)
        }
    }
}

struct MyStruct {
    var title: String
}

// This is an immutable struct
// immutable means everything inside the struct will be let
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    // (set) means we can get the var title's value from anywhere in our code but we can't set it
    // we can set it only via the updateTitle() func
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func structTest2() {
        print("structTest2()")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1:", struct1.title)
        struct1.title = "Title2" // mutate the title
        print("Struct1:", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2:", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2:", struct2.title)
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3:", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3:", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4:", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4:", struct4.title)

    }
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    private func classTest2() {
        print("classTest2()")
        
        let class1 = MyClass(title: "Title1")
        print("Class1:", class1.title)
        class1.title = "Title2"
        print("Class1:", class1.title)
        
        let class2 = MyClass(title: "Title2")
        print("Class2:", class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("Class1:", class1.title)
    }
}
