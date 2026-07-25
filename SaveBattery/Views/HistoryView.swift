import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.sessions.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.badge.questionmark")
                            .font(.system(size: 44))
                            .foregroundStyle(.secondary)
                        Text(NSLocalizedString("history_empty_title", comment: ""))
                            .font(.headline)
                        Text(NSLocalizedString("history_empty_description", comment: ""))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else {
                    List(viewModel.sessions) { session in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.startDate, style: .date)
                                .font(.headline)
                            HStack {
                                Text(viewModel.levelText(for: session))
                                Spacer()
                                Text(viewModel.durationText(for: session))
                                    .foregroundStyle(.secondary)
                            }
                            .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("tab_history", comment: ""))
        }
    }
}

#Preview {
    HistoryView()
}
