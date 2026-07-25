import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section(NSLocalizedString("settings_charge_reminder_section", comment: "")) {
                    Toggle(NSLocalizedString("settings_charge_reminder_toggle", comment: ""), isOn: $viewModel.chargeLimitReminderEnabled)
                        .onChange(of: viewModel.chargeLimitReminderEnabled) { enabled in
                            if enabled {
                                viewModel.requestNotificationPermission()
                            }
                        }

                    if viewModel.chargeLimitReminderEnabled {
                        VStack(alignment: .leading) {
                            Text(String(format: NSLocalizedString("settings_charge_limit_value", comment: ""), Int(viewModel.chargeLimitPercent)))
                            Slider(value: $viewModel.chargeLimitPercent, in: 50...100, step: 5)
                        }
                    }
                }

                Section {
                    Text(NSLocalizedString("settings_footer_note", comment: ""))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(NSLocalizedString("tab_settings", comment: ""))
        }
    }
}

#Preview {
    SettingsView()
}
