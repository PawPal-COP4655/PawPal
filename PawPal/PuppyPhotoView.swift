
import SwiftUI
import PhotosUI
import UIKit

struct PuppyPhotoView: View {

    let isEditable: Bool

    @AppStorage("PawPalPuppyPhoto")
    private var savedPhotoData: Data = Data()

    @State private var selectedPhoto: PhotosPickerItem?

    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 12) {

            puppyImage
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(
                            PawPalColors.mutedGreen.opacity(0.2),
                            lineWidth: 1
                        )
                }

            if isEditable {
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label(
                        "Choose Puppy Photo",
                        systemImage: "camera"
                    )
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(PawPalColors.darkGreen)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }
                .disabled(isLoading)

                if isLoading {
                    ProgressView("Loading photo...")
                        .tint(PawPalColors.darkGreen)
                }

                if !savedPhotoData.isEmpty {
                    Button("Remove Photo") {
                        savedPhotoData = Data()
                        selectedPhoto = nil
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(.red)
                }
            }
        }
        .onChange(of: selectedPhoto) { newPhoto in
            Task {
                await loadSelectedPhoto(newPhoto)
            }
        }
    }

    @ViewBuilder
    private var puppyImage: some View {
        if let image = UIImage(data: savedPhotoData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
        } else {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 40))
                .foregroundStyle(PawPalColors.darkGreen)
                .frame(width: 100, height: 100)
                .background(
                    PawPalColors.background,
                    in: Circle()
                )
        }
    }

    @MainActor
    private func loadSelectedPhoto(
        _ photo: PhotosPickerItem?
    ) async {
        guard let photo else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }

        do {
            guard let imageData = try await photo.loadTransferable(
                type: Data.self
            ) else {
                return
            }

            guard let image = UIImage(data: imageData) else {
                return
            }

            let maxDimension: CGFloat = 600

            let scale = min(
                1,
                maxDimension / max(
                    image.size.width,
                    image.size.height
                )
            )

            let newSize = CGSize(
                width: image.size.width * scale,
                height: image.size.height * scale
            )

            let renderer = UIGraphicsImageRenderer(
                size: newSize
            )

            let resizedImage = renderer.image { _ in
                image.draw(
                    in: CGRect(
                        origin: .zero,
                        size: newSize
                    )
                )
            }

            if let compressedData = resizedImage.jpegData(
                compressionQuality: 0.7
            ) {
                savedPhotoData = compressedData
            }

        } catch {
            print("Unable to load puppy photo: \(error)")
        }
    }
}
