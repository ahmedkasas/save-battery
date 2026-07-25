import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label(NSLocalizedString("tab_dashboard", comment: ""), systemImage: "battery.100")
                }

            HistoryView()
                .tabItem {
                    Label(NSLocalizedString("tab_history", comment: ""), systemImage: "clock.arrow.circlepath")
                }

            TipsView()
                .tabItem {
                    Label(NSLocalizedString("tab_tips", comment: ""), systemImage: "lightbulb")
                }

            SettingsView()
                .tabItem {
                    Label(NSLocalizedString("tab_settings", comment: ""), systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    RootTabView()
}
