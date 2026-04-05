import SwiftUI

@main
struct KillTeamCardsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TeamSelectionView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
