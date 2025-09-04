import SwiftData

final class Persistence {
    @MainActor
    static let shared = Persistence()
    
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    @MainActor
    init() {
        self.modelContainer = try! ModelContainer(
            for: Footprint.self, Pin.self, ScannedTree.self, User.self
        )
        self.modelContext = modelContainer.mainContext
    }
}
