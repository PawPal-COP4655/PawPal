
import SwiftUI

struct ShareCareView: View {
    @ObservedObject var store: PawPalStore

    private var puppyName: String {
        store.profile.name.isEmpty
            ? "My Puppy"
            : store.profile.name
    }

    private var puppyBreed: String {
        store.profile.breed.isEmpty
            ? "Not provided"
            : store.profile.breed
    }

    private var recentActivities: [CareActivity] {
        Array(
            store.activities
                .sorted { $0.date > $1.date }
                .prefix(10)
        )
    }

    private var careSummary: String {
        var lines: [String] = [
            "PawPal - Puppy Care Summary",
            "",
            "Puppy Profile",
            "Name: \(puppyName)",
            "Breed: \(puppyBreed)",
            "Age: \(store.profile.ageInMonths) months"
        ]

        if let weight = store.latestWeight {
            lines.append(
                String(format: "Latest Weight: %.1f lbs", weight)
            )
        }

        lines.append("")
        lines.append("Recent Activities")

        if recentActivities.isEmpty {
            lines.append("No activities recorded yet.")
        } else {
            for activity in recentActivities {
                let status = activity.isCompleted
                    ? "Completed"
                    : "Pending"

                let dateText = activity.date.formatted(
                    date: .abbreviated,
                    time: .shortened
                )

                lines.append(
                    "\(activity.title) - \(dateText) - \(status)"
                )

                if !activity.notes.isEmpty {
                    lines.append("Notes: \(activity.notes)")
                }
            }
        }

        lines.append("")
        lines.append("Shared from PawPal")

        return lines.joined(separator: "\n")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                PawPalHeader(
                    title: "Share Care Info",
                    subtitle: "Keep your puppy's caregivers informed"
                )

                // MARK: - Profile Summary

                VStack(alignment: .leading, spacing: 16) {

                    Label(
                        "Puppy Summary",
                        systemImage: "pawprint.fill"
                    )
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(PawPalColors.darkGreen)

                    Divider()

                    summaryRow(
                        title: "Name",
                        value: puppyName
                    )

                    summaryRow(
                        title: "Breed",
                        value: puppyBreed
                    )

                    summaryRow(
                        title: "Age",
                        value: "\(store.profile.ageInMonths) months"
                    )

                    if let weight = store.latestWeight {
                        summaryRow(
                            title: "Latest Weight",
                            value: String(
                                format: "%.1f lbs",
                                weight
                            )
                        )
                    }
                }
                .padding(20)
                .background(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )

                // MARK: - Recent Activities

                VStack(alignment: .leading, spacing: 16) {

                    Text("Recent Activities")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(PawPalColors.darkGreen)

                    if recentActivities.isEmpty {
                        PawPalEmptyState(
                            symbol: "list.clipboard",
                            title: "No activities yet",
                            message: "Your puppy's recent activities will appear here."
                        )
                    } else {
                        ForEach(recentActivities) { activity in
                            PawPalActivityCard(
                                activity: activity
                            )
                        }
                    }
                }

                // MARK: - Share Button

                ShareLink(item: careSummary) {
                    Label(
                        "Share Care Summary",
                        systemImage: "square.and.arrow.up"
                    )
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .foregroundStyle(.white)
                    .background(PawPalColors.darkGreen)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14)
                    )
                }
                .buttonStyle(.plain)

                Text(
                    "Only the information shown in this summary and the notes from recent activities will be shared."
                )
                .font(.system(size: 12))
                .foregroundStyle(PawPalColors.mutedGreen)
            }
            .padding(24)
        }
        .background(PawPalColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }

    // MARK: - Summary Row

    private func summaryRow(
        title: String,
        value: String
    ) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundStyle(PawPalColors.mutedGreen)

            Spacer()

            Text(value)
                .fontWeight(.medium)
                .foregroundStyle(PawPalColors.darkGreen)
                .multilineTextAlignment(.trailing)
        }
        .font(.system(size: 14))
    }
}
