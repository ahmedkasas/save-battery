import SwiftUI

struct TipsView: View {
    private let tipKeys = [
        "tip_enable_low_power_mode",
        "tip_reduce_brightness",
        "tip_background_refresh",
        "tip_avoid_extreme_temperatures",
        "tip_avoid_full_discharge",
        "tip_use_wifi_over_cellular",
        "tip_disable_unused_widgets",
        "tip_optimized_battery_charging"
    ]

    var body: some View {
        NavigationStack {
            List(tipKeys, id: \.self) { key in
                Text(NSLocalizedString(key, comment: ""))
                    .padding(.vertical, 4)
            }
            .navigationTitle(NSLocalizedString("tab_tips", comment: ""))
        }
    }
}

#Preview {
    TipsView()
}
