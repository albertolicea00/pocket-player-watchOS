import SwiftUI

@main
struct PocketPlayerWatchApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LibraryView()
            }
        }
    }
}
