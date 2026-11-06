
import SwiftUI

struct EditProfileView: View {
    @ObservedObject var store: PawPalStore
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var breed: String
    @State private var ageText: String

    init(store: PawPalStore) {
        self.store = store

        _name = State(initialValue: store.profile.name)
        _breed = State(initialValue: store.profile.breed)
        _ageText = State(
            initialValue: store.profile.ageInMonths == 0
                ? ""
                : String(store.profile.ageInMonths)
        )
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedBreed: String {
        breed.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var validAge: Int? {
        guard let age = Int(ageText), age >= 0 else {
            return nil
        }
        return age
    }

    private var canSave: Bool {
        !trimmedName.isEmpty &&
        !trimmedBreed.isEmpty &&
        validAge != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                PawPalHeader(
                    title: "Edit Profile",
                    subtitle: "Update your puppy's information"
                )

                // MARK: - Puppy Photo

                VStack(spacing: 12) {
                    PuppyPhotoView(isEditable: true)

                    Text("Add a photo of your puppy")
                        .font(.system(size: 13))
                        .foregroundStyle(PawPalColors.mutedGreen)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)

                // MARK: - Name

                VStack(alignment: .leading, spacing: 12) {
                    Text("Name")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(PawPalColors.darkGreen)

                    TextField("Enter puppy's name", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .padding(16)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                }

                // MARK: - Breed

                VStack(alignment: .leading, spacing: 12) {
                    Text("Breed")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(PawPalColors.darkGreen)

                    TextField("Enter puppy's breed", text: $breed)
                        .textInputAutocapitalization(.words)
                        .padding(16)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                }

                // MARK: - Age

                VStack(alignment: .leading, spacing: 12) {
                    Text("Age (Months)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(PawPalColors.darkGreen)

                    TextField("Enter age in months", text: $ageText)
                        .keyboardType(.numberPad)
                        .padding(16)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                }

                // MARK: - Save Button

                Button(action: saveProfile) {
                    Text("Save Changes")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .foregroundStyle(.white)
                        .background(
                            canSave
                                ? PawPalColors.darkGreen
                                : PawPalColors.mutedGreen
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                }
                .disabled(!canSave)
                .padding(.top, 8)

                if !canSave {
                    Text("Enter a name, breed, and valid age to save.")
                        .font(.system(size: 13))
                        .foregroundStyle(PawPalColors.mutedGreen)
                }
            }
            .padding(24)
        }
        .background(PawPalColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }

    private func saveProfile() {
        guard canSave, let age = validAge else {
            return
        }

        store.updateProfile(
            name: trimmedName,
            breed: trimmedBreed,
            ageInMonths: age
        )

        dismiss()
    }
}
