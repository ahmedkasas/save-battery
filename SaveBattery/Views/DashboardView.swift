import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: batteryIconName)
                            .font(.system(size: 40))
                            .foregroundStyle(batteryColor)
                        VStack(alignment: .leading) {
                            Text(viewModel.levelPercentText)
                                .font(.largeTitle.bold())
                            Text(NSLocalizedString(viewModel.stateDescriptionKey, comment: ""))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                if viewModel.isLowPowerModeEnabled {
                    Section {
                        Label(NSLocalizedString("low_power_mode_active", comment: ""), systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }

                Section(NSLocalizedString("dashboard_tips_section", comment: "")) {
                    ForEach(viewModel.tipKeys, id: \.self) { key in
                        Label(NSLocalizedString(key, comment: ""), systemImage: "lightbulb")
                    }
                }

                Section {
                    Button(NSLocalizedString("open_system_settings", comment: "")) {
                        viewModel.openSystemSettings()
                    }
                }
            }
            .navigationTitle(NSLocalizedString("app_name", comment: ""))
        }
    }

    private var batteryIconName: String {
        if viewModel.status.state == .charging || viewModel.status.state == .full {
            return "battery.100.bolt"
        }
        switch viewModel.status.level {
        case ..<0.2: return "battery.25"
        case ..<0.5: return "battery.50"
        case ..<0.75: return "battery.75"
        default: return "battery.100"
        }
    }

    private var batteryColor: Color {
        if viewModel.status.level >= 0, viewModel.status.level < 0.2, viewModel.status.state != .charging {
            return .red
        }
        return .green
    }
}

#Preview {
    DashboardView()
}
