import SwiftUI

@main
struct SaveBatteryApp: App {
    init() {
        NotificationService.shared.requestAuthorizationIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}
