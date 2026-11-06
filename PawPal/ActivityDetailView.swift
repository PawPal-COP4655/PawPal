
import SwiftUI

struct ActivityDetailView: View {
    @ObservedObject var store: PawPalStore
    @Environment(\.dismiss) private var dismiss

    let activityID: UUID

    @State private var showingDeleteConfirmation = false

    private var activity: CareActivity? {
        store.activities.first { $0.id == activityID }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                PawPalHeader(
                    title: "Activity Detail",
                    subtitle: "View your puppy's activity"
                )

                if let activity = activity {

                    activityInformation(activity)

                    // MARK: - Completion Button

                    Button {
                        updateCompletion(activity)
                    } label: {
                        Text(
                            activity.isCompleted
                                ? "Mark as Pending"
                                : "Mark as Completed"
                        )
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(PawPalColors.darkGreen)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                    }
                    .buttonStyle(.plain)

                    // MARK: - Delete Button

                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        Label(
                            "Delete Activity",
                            systemImage: "trash"
                        )
                        .font(.system(size: 15, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                } else {
                    PawPalEmptyState(
                        symbol: "exclamationmark.circle",
                        title: "Activity Not Found",
                        message: "This activity is no longer available."
                    )
                }
            }
            .padding(24)
        }
        .background(PawPalColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .confirmationDialog(
            "Delete Activity?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete Activity", role: .destructive) {
                deleteActivity()
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This activity will be permanently deleted.")
        }
    }

    // MARK: - Activity Information

    private func activityInformation(
        _ activity: CareActivity
    ) -> some View {
        VStack(alignment: .leading, spacing: 18) {

            informationRow(
                title: "Activity Type",
                value: activity.title
            )

            Divider()

            informationRow(
                title: "Date & Time",
                value: activity.date.formatted(
                    date: .abbreviated,
                    time: .shortened
                )
            )

            Divider()

            informationRow(
                title: "Notes",
                value: activity.notes.isEmpty
                    ? "No notes added"
                    : activity.notes
            )

            Divider()

            HStack {
                Text("Status")
                    .foregroundStyle(PawPalColors.mutedGreen)

                Spacer()

                Text(
                    activity.isCompleted
                        ? "Completed"
                        : "Pending"
                )
                .fontWeight(.semibold)
                .foregroundStyle(
                    activity.isCompleted
                        ? PawPalColors.completedGreen
                        : PawPalColors.pendingBrown
                )
            }
            .font(.system(size: 14))

            if let completedAt = activity.completedAt {
                Divider()

                informationRow(
                    title: "Completed On",
                    value: completedAt.formatted(
                        date: .abbreviated,
                        time: .shortened
                    )
                )
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }

    // MARK: - Information Row

    private func informationRow(
        title: String,
        value: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(PawPalColors.mutedGreen)

            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(PawPalColors.darkGreen)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
        }
    }

    // MARK: - Update Completion

    private func updateCompletion(
        _ activity: CareActivity
    ) {
        if !activity.isCompleted {
            // Cancel any pending reminder when completed.
            NotificationManager.cancelReminder(
                for: activity.id
            )
        }

        store.toggleCompletion(for: activity)

        dismiss()
    }

    // MARK: - Delete Activity

    private func deleteActivity() {
        // Cancel the reminder before deleting the activity.
        NotificationManager.cancelReminder(
            for: activityID
        )

        store.deleteActivity(id: activityID)

        dismiss()
    }
}
