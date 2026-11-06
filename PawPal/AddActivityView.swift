
import SwiftUI

struct AddActivityView: View {
    @ObservedObject var store: PawPalStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: ActivityCategory = .feeding
    @State private var selectedDate = Date()
    @State private var notes = ""
    @State private var remindMe = false
    @State private var isSaving = false
    @State private var reminderMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                PawPalHeader(
                    title: "Add Activity",
                    subtitle: "Keep track of your puppy's routine"
                )

                // MARK: - Activity Type

                VStack(alignment: .leading, spacing: 12) {
                    Text("Activity Type")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(PawPalColors.darkGreen)

                    Picker(
                        "Activity Type",
                        selection: $selectedCategory
                    ) {
                        ForEach(ActivityCategory.allCases) { category in
                            Label(
                                category.rawValue,
                                systemImage: category.symbol
                            )
                            .tag(category)
                        }
                    }
                    .tint(PawPalColors.darkGreen)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(12)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }

                // MARK: - Date and Time

                VStack(alignment: .leading, spacing: 12) {
                    Text("Date & Time")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(PawPalColors.darkGreen)

                    DatePicker(
                        "Activity Date",
                        selection: $selectedDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    .tint(PawPalColors.darkGreen)
                    .padding(16)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }

                // MARK: - Reminder

                Toggle(isOn: $remindMe) {
                    Label(
                        "Remind Me",
                        systemImage: "bell"
                    )
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(PawPalColors.darkGreen)
                }
                .tint(PawPalColors.completedGreen)
                .padding(16)
                .background(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

                if remindMe {
                    Text(
                        "PawPal will request notification permission and schedule a reminder for the selected date and time."
                    )
                    .font(.system(size: 13))
                    .foregroundStyle(PawPalColors.mutedGreen)

                    if selectedDate <= Date() {
                        Text(
                            "Choose a future date and time to schedule a reminder."
                        )
                        .font(.system(size: 13))
                        .foregroundStyle(PawPalColors.pendingBrown)
                    }
                }

                // MARK: - Notes

                VStack(alignment: .leading, spacing: 12) {
                    Text("Notes (Optional)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(PawPalColors.darkGreen)

                    ZStack(alignment: .topLeading) {
                        if notes.isEmpty {
                            Text("Add notes about this activity...")
                                .font(.system(size: 14))
                                .foregroundStyle(
                                    PawPalColors.mutedGreen.opacity(0.7)
                                )
                                .padding(.top, 12)
                                .padding(.leading, 7)
                                .allowsHitTesting(false)
                        }

                        TextEditor(text: $notes)
                            .font(.system(size: 14))
                            .foregroundStyle(PawPalColors.darkGreen)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 100)
                    }
                    .padding(12)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }

                // MARK: - Save

                Button {
                    Task {
                        await saveActivity()
                    }
                } label: {
                    if isSaving {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                    } else {
                        Text("Save Activity")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                    }
                }
                .foregroundStyle(.white)
                .background(PawPalColors.darkGreen)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
                .disabled(
                    isSaving ||
                    (remindMe && selectedDate <= Date())
                )
                .padding(.top, 6)
            }
            .padding(24)
        }
        .background(PawPalColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .alert(
            "Reminder Notice",
            isPresented: Binding(
                get: { reminderMessage != nil },
                set: { if !$0 { reminderMessage = nil } }
            )
        ) {
            Button("OK") {
                reminderMessage = nil
                dismiss()
            }
        } message: {
            Text(reminderMessage ?? "")
        }
    }

    // MARK: - Save Activity

    @MainActor
    private func saveActivity() async {
        guard !isSaving else {
            return
        }

        if remindMe && selectedDate <= Date() {
            return
        }

        isSaving = true
        defer {
            isSaving = false
        }

        let activity = CareActivity(
            category: selectedCategory,
            date: selectedDate,
            notes: notes.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        )

        if remindMe {
            let permissionGranted =
                await NotificationManager.requestPermission()

            if permissionGranted {
                do {
                    try await NotificationManager.scheduleReminder(
                        for: activity,
                        puppyName: store.profile.name
                    )
                } catch {
                    store.activities.append(activity)
                    reminderMessage =
                        "Activity saved, but the reminder could not be scheduled."
                    return
                }
            } else {
                store.activities.append(activity)
                reminderMessage =
                    "Activity saved, but notification permission was not granted."
                return
            }
        }

        store.activities.append(activity)
        dismiss()
    }
}
