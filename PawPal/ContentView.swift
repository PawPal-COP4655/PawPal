
import SwiftUI

// MARK: - PawPal Colors

enum PawPalColors {
    static let background = Color(
        red: 248 / 255,
        green: 245 / 255,
        blue: 238 / 255
    )

    static let darkGreen = Color(
        red: 52 / 255,
        green: 78 / 255,
        blue: 65 / 255
    )

    static let mutedGreen = Color(
        red: 120 / 255,
        green: 135 / 255,
        blue: 125 / 255
    )

    static let completedGreen = Color(
        red: 72 / 255,
        green: 121 / 255,
        blue: 85 / 255
    )

    static let pendingBrown = Color(
        red: 150 / 255,
        green: 110 / 255,
        blue: 54 / 255
    )
}

// MARK: - Main Navigation

struct ContentView: View {
    @StateObject private var store = PawPalStore()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeScreen(store: store)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)

            NavigationStack {
                ActivitiesScreen(store: store)
            }
            .tabItem {
                Label("Activities", systemImage: "list.bullet")
            }
            .tag(1)

            NavigationStack {
                HistoryScreen(store: store)
            }
            .tabItem {
                Label(
                    "History",
                    systemImage: "clock.arrow.circlepath"
                )
            }
            .tag(2)

            NavigationStack {
                ProfileScreen(store: store)
            }
            .tabItem {
                Label(
                    "Profile",
                    systemImage: "person.crop.circle"
                )
            }
            .tag(3)
        }
        .tint(PawPalColors.darkGreen)
    }
}

// MARK: - Shared Components

struct PawPalHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(PawPalColors.darkGreen)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundStyle(PawPalColors.mutedGreen)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}

struct PawPalEmptyState: View {
    let symbol: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 36))
                .foregroundStyle(PawPalColors.mutedGreen)

            Text(title)
                .font(.headline)
                .foregroundStyle(PawPalColors.darkGreen)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(PawPalColors.mutedGreen)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

struct PawPalActivityCard: View {
    let activity: CareActivity

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: activity.category.symbol)
                .font(.title3)
                .foregroundStyle(PawPalColors.darkGreen)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 5) {
                Text(activity.title)
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(PawPalColors.darkGreen)

                Text(activity.date, style: .time)
                    .font(.system(size: 13))
                    .foregroundStyle(PawPalColors.mutedGreen)
            }

            Spacer()

            Text(
                activity.isCompleted
                    ? "Completed"
                    : "Pending"
            )
            .font(
                .system(
                    size: 12,
                    weight: .medium
                )
            )
            .foregroundStyle(
                activity.isCompleted
                    ? PawPalColors.completedGreen
                    : PawPalColors.pendingBrown
            )
        }
        .padding(18)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

// MARK: - Activity Navigation

struct PawPalActivityLink: View {
    @ObservedObject var store: PawPalStore
    let activity: CareActivity

    var body: some View {
        NavigationLink {
            ActivityDetailView(
                store: store,
                activityID: activity.id
            )
        } label: {
            PawPalActivityCard(activity: activity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Add Activity Button

struct PawPalAddActivityButton: View {
    @ObservedObject var store: PawPalStore

    var body: some View {
        NavigationLink {
            AddActivityView(store: store)
        } label: {
            Label(
                "Add Activity",
                systemImage: "plus"
            )
            .font(
                .system(
                    size: 16,
                    weight: .semibold
                )
            )
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
}

// MARK: - Home Screen

struct HomeScreen: View {
    @ObservedObject var store: PawPalStore

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                PawPalHeader(
                    title: "PawPal",
                    subtitle: "Your puppy's daily companion"
                )

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {
                    Text("Today's Activities")
                        .font(
                            .system(
                                size: 22,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(PawPalColors.darkGreen)

                    if store.todaysActivities.isEmpty {
                        PawPalEmptyState(
                            symbol: "calendar.badge.clock",
                            title: "No activities yet",
                            message: "Your puppy's daily routine will appear here."
                        )
                    } else {
                        ForEach(
                            store.todaysActivities
                        ) { activity in
                            PawPalActivityLink(
                                store: store,
                                activity: activity
                            )
                        }
                    }

                    PawPalAddActivityButton(store: store)
                }
            }
            .padding(24)
        }
        .background(PawPalColors.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Activities Screen

struct ActivitiesScreen: View {
    @ObservedObject var store: PawPalStore

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                PawPalHeader(
                    title: "Activities",
                    subtitle: "Manage your puppy's routine"
                )

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {
                    Text("All Activities")
                        .font(
                            .system(
                                size: 22,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(PawPalColors.darkGreen)

                    PawPalAddActivityButton(store: store)

                    if store.activities.isEmpty {
                        PawPalEmptyState(
                            symbol: "list.clipboard",
                            title: "No activities",
                            message: "Activities you add will appear here."
                        )
                    } else {
                        ForEach(
                            store.activities.sorted {
                                $0.date < $1.date
                            }
                        ) { activity in
                            PawPalActivityLink(
                                store: store,
                                activity: activity
                            )
                        }
                    }
                }
            }
            .padding(24)
        }
        .background(PawPalColors.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - History Screen

struct HistoryScreen: View {
    @ObservedObject var store: PawPalStore

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                PawPalHeader(
                    title: "History",
                    subtitle: "Your puppy's completed activities"
                )

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {
                    Text("Completed Activities")
                        .font(
                            .system(
                                size: 22,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(PawPalColors.darkGreen)

                    if store.completedActivities.isEmpty {
                        PawPalEmptyState(
                            symbol: "checkmark.circle",
                            title: "No completed activities",
                            message: "Your puppy's completed tasks will appear here."
                        )
                    } else {
                        ForEach(
                            store.completedActivities
                        ) { activity in
                            PawPalActivityLink(
                                store: store,
                                activity: activity
                            )
                        }
                    }
                }
            }
            .padding(24)
        }
        .background(PawPalColors.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}


// MARK: - Profile Screen

struct ProfileScreen: View {
   @ObservedObject var store: PawPalStore

   var body: some View {
       ScrollView {
           VStack(alignment: .leading, spacing: 24) {
               PawPalHeader(
                   title: "Profile",
                   subtitle: "Your puppy's information"
               )

               VStack(spacing: 18) {
                   PuppyPhotoView(isEditable: false)

                   Text(
                       store.profile.name.isEmpty
                           ? "Your Puppy"
                           : store.profile.name
                   )
                   .font(.system(size: 24, weight: .bold))
                   .foregroundStyle(PawPalColors.darkGreen)

                   Text(
                       store.profile.breed.isEmpty
                           ? "Add your puppy's information"
                           : store.profile.breed
                   )
                   .font(.subheadline)
                   .foregroundStyle(PawPalColors.mutedGreen)

                   Divider()

                   profileRow(
                       title: "Name",
                       value: store.profile.name.isEmpty
                           ? "Not set"
                           : store.profile.name
                   )

                   profileRow(
                       title: "Breed",
                       value: store.profile.breed.isEmpty
                           ? "Not set"
                           : store.profile.breed
                   )

                   profileRow(
                       title: "Age",
                       value: "\(store.profile.ageInMonths) months"
                   )

                   if let latestWeight = store.latestWeight {
                       profileRow(
                           title: "Latest Weight",
                           value: String(
                               format: "%.1f lbs",
                               latestWeight
                           )
                       )
                   }
               }
               .padding(24)
               .frame(maxWidth: .infinity)
               .background(.white)
               .clipShape(
                   RoundedRectangle(cornerRadius: 16)
               )

               // MARK: - Edit Profile

               NavigationLink {
                   EditProfileView(store: store)
               } label: {
                   Text("Edit Profile")
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

               // MARK: - Weight Tracking

               NavigationLink {
                   WeightTrackingView(store: store)
               } label: {
                   Label(
                       "Weight Tracking",
                       systemImage: "chart.bar"
                   )
                   .font(.system(size: 16, weight: .semibold))
                   .frame(maxWidth: .infinity)
                   .frame(height: 52)
                   .foregroundStyle(PawPalColors.darkGreen)
                   .background(.white)
                   .overlay {
                       RoundedRectangle(cornerRadius: 14)
                           .stroke(
                               PawPalColors.darkGreen,
                               lineWidth: 1
                           )
                   }
                   .clipShape(
                       RoundedRectangle(cornerRadius: 14)
                   )
               }
               .buttonStyle(.plain)

               // MARK: - Share Care Info

               NavigationLink {
                   ShareCareView(store: store)
               } label: {
                   Label(
                       "Share Care Info",
                       systemImage: "square.and.arrow.up"
                   )
                   .font(.system(size: 16, weight: .semibold))
                   .frame(maxWidth: .infinity)
                   .frame(height: 52)
                   .foregroundStyle(PawPalColors.darkGreen)
                   .background(.white)
                   .overlay {
                       RoundedRectangle(cornerRadius: 14)
                           .stroke(
                               PawPalColors.darkGreen,
                               lineWidth: 1
                           )
                   }
                   .clipShape(
                       RoundedRectangle(cornerRadius: 14)
                   )
               }
               .buttonStyle(.plain)
           }
           .padding(24)
       }
       .background(PawPalColors.background)
       .toolbar(.hidden, for: .navigationBar)
   }

   private func profileRow(
       title: String,
       value: String
   ) -> some View {
       HStack {
           Text(title)
               .foregroundStyle(PawPalColors.mutedGreen)

           Spacer()

           Text(value)
               .fontWeight(.medium)
               .foregroundStyle(PawPalColors.darkGreen)
       }
       .font(.system(size: 14))
   }
}

#Preview {
    ContentView()
}
