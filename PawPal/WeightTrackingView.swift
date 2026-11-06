
import SwiftUI
import Charts

struct WeightTrackingView: View {
    @ObservedObject var store: PawPalStore

    @State private var weightText = ""
    @State private var selectedDate = Date()
    @State private var showingAddWeight = false

    private var validWeight: Double? {
        let normalizedText = weightText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        guard let weight = Double(normalizedText),
              weight > 0,
              weight.isFinite else {
            return nil
        }

        return weight
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                PawPalHeader(
                    title: "Weight Tracking",
                    subtitle: "Monitor your puppy's growth"
                )

                latestWeightCard

                VStack(alignment: .leading, spacing: 16) {
                    Text("Weight History")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(PawPalColors.darkGreen)

                    if store.weightRecords.isEmpty {
                        PawPalEmptyState(
                            symbol: "chart.xyaxis.line",
                            title: "No weight records",
                            message: "Add your puppy's first weight to start tracking growth."
                        )
                    } else {
                        weightChart
                        weightHistoryList
                    }
                }

                Button {
                    showingAddWeight = true
                } label: {
                    Label("Add Weight", systemImage: "plus")
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
            }
            .padding(24)
        }
        .background(PawPalColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .sheet(isPresented: $showingAddWeight) {
            addWeightSheet
        }
    }

    // MARK: - Latest Weight

    private var latestWeightCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("LATEST WEIGHT")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(PawPalColors.mutedGreen)

            if let latestWeight = store.latestWeight {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(latestWeight, format: .number.precision(
                        .fractionLength(1)
                    ))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(PawPalColors.darkGreen)

                    Text("lbs")
                        .font(.system(size: 17))
                        .foregroundStyle(PawPalColors.mutedGreen)
                }
            } else {
                Text("No weight recorded")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(PawPalColors.darkGreen)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Weight Chart

    private var weightChart: some View {
        Chart {
            ForEach(store.sortedWeightRecords) { record in
                LineMark(
                    x: .value("Date", record.date),
                    y: .value("Weight", record.weightInPounds)
                )
                .foregroundStyle(PawPalColors.darkGreen)

                PointMark(
                    x: .value("Date", record.date),
                    y: .value("Weight", record.weightInPounds)
                )
                .foregroundStyle(PawPalColors.completedGreen)
            }
        }
        .frame(height: 200)
        .chartYAxisLabel("Weight (lbs)")
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Weight History

    private var weightHistoryList: some View {
        VStack(spacing: 12) {
            ForEach(
                store.sortedWeightRecords.reversed()
            ) { record in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(
                            record.date.formatted(
                                date: .abbreviated,
                                time: .omitted
                            )
                        )
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(PawPalColors.darkGreen)

                        Text("Weight record")
                            .font(.system(size: 12))
                            .foregroundStyle(PawPalColors.mutedGreen)
                    }

                    Spacer()

                    Text(
                        record.weightInPounds,
                        format: .number.precision(
                            .fractionLength(1)
                        )
                    )
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(PawPalColors.darkGreen)

                    Text("lbs")
                        .font(.system(size: 13))
                        .foregroundStyle(PawPalColors.mutedGreen)

                    Button(role: .destructive) {
                        store.deleteWeightRecord(id: record.id)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                            .padding(.leading, 8)
                    }
                    .accessibilityLabel("Delete weight record")
                }
                .padding(18)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    // MARK: - Add Weight Sheet

    private var addWeightSheet: some View {
        NavigationStack {
            Form {
                Section("Weight") {
                    HStack {
                        TextField(
                            "Enter weight",
                            text: $weightText
                        )
                        .keyboardType(.decimalPad)

                        Text("lbs")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Date") {
                    DatePicker(
                        "Recorded On",
                        selection: $selectedDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("Add Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAddWeight = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWeight()
                    }
                    .disabled(validWeight == nil)
                }
            }
            .tint(PawPalColors.darkGreen)
        }
    }

    // MARK: - Save Weight

    private func saveWeight() {
        guard let weight = validWeight else {
            return
        }

        store.addWeight(weight, on: selectedDate)

        weightText = ""
        selectedDate = Date()
        showingAddWeight = false
    }
}
