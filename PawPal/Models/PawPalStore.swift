import Foundation
import SwiftUI
import Combine

// MARK: - Puppy Profile

struct PuppyProfile: Codable {
    var name: String = ""
    var breed: String = ""
    var ageInMonths: Int = 0
}

// MARK: - Activity Categories

enum ActivityCategory: String, Codable, CaseIterable, Identifiable {
    case feeding = "Feeding"
    case potty = "Potty Break"
    case grooming = "Grooming"
    case playtime = "Playtime"
    case medication = "Medication"
    case other = "Other"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .feeding:
            return "fork.knife"
        case .potty:
            return "pawprint"
        case .grooming:
            return "sparkles"
        case .playtime:
            return "tennisball"
        case .medication:
            return "cross.vial"
        case .other:
            return "checklist"
        }
    }
}

// MARK: - Puppy Care Activity

struct CareActivity: Identifiable, Codable {
    var id: UUID = UUID()
    var category: ActivityCategory
    var date: Date
    var notes: String
    var isCompleted: Bool = false
    var completedAt: Date? = nil

    var title: String {
        category.rawValue
    }
}

// MARK: - Weight Record

struct WeightRecord: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var weightInPounds: Double
}

// MARK: - Data Store

@MainActor
final class PawPalStore: ObservableObject {

    @Published var profile: PuppyProfile {
        didSet {
            save()
        }
    }

    @Published var activities: [CareActivity] {
        didSet {
            save()
        }
    }

    @Published var weightRecords: [WeightRecord] {
        didSet {
            save()
        }
    }

    private let storageKey = "PawPalSavedData"

    private struct SavedData: Codable {
        var profile: PuppyProfile
        var activities: [CareActivity]
        var weightRecords: [WeightRecord]
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let savedData = try? JSONDecoder().decode(
                SavedData.self,
                from: data
           ) {

            self.profile = savedData.profile
            self.activities = savedData.activities
            self.weightRecords = savedData.weightRecords

        } else {
            self.profile = PuppyProfile()
            self.activities = []
            self.weightRecords = []
        }
    }

    // MARK: - Save Data

    private func save() {
        let savedData = SavedData(
            profile: profile,
            activities: activities,
            weightRecords: weightRecords
        )

        guard let data = try? JSONEncoder().encode(savedData) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }

    // MARK: - Profile

    func updateProfile(name: String, breed: String, ageInMonths: Int) {
        profile = PuppyProfile(
            name: name,
            breed: breed,
            ageInMonths: max(0, ageInMonths)
        )
    }

    // MARK: - Activities

    func addActivity(
        category: ActivityCategory,
        date: Date,
        notes: String
    ) {
        let activity = CareActivity(
            category: category,
            date: date,
            notes: notes
        )

        activities.append(activity)
    }

    func toggleCompletion(for activity: CareActivity) {
        guard let index = activities.firstIndex(
            where: { $0.id == activity.id }
        ) else {
            return
        }

        activities[index].isCompleted.toggle()

        activities[index].completedAt =
            activities[index].isCompleted ? Date() : nil
    }

    func deleteActivity(id: UUID) {
        activities.removeAll { $0.id == id }
    }

    // MARK: - Activity Lists

    var todaysActivities: [CareActivity] {
        activities
            .filter {
                Calendar.current.isDateInToday($0.date)
            }
            .sorted { $0.date < $1.date }
    }

    var pendingActivities: [CareActivity] {
        activities
            .filter { !$0.isCompleted }
            .sorted { $0.date < $1.date }
    }

    var completedActivities: [CareActivity] {
        activities
            .filter { $0.isCompleted }
            .sorted {
                ($0.completedAt ?? $0.date) >
                ($1.completedAt ?? $1.date)
            }
    }

    // MARK: - Weight Tracking

    func addWeight(_ weight: Double, on date: Date = Date()) {
        guard weight > 0 else {
            return
        }

        let record = WeightRecord(
            date: date,
            weightInPounds: weight
        )

        weightRecords.append(record)
    }

    func deleteWeightRecord(id: UUID) {
        weightRecords.removeAll { $0.id == id }
    }

    var sortedWeightRecords: [WeightRecord] {
        weightRecords.sorted { $0.date < $1.date }
    }

    var latestWeight: Double? {
        sortedWeightRecords.last?.weightInPounds
    }
}
