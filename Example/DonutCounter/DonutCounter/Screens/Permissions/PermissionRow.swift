import Foundation
import SwiftUI

struct PermissionsRow: View {
    let title: String
    let description: String
    var isPermissionGranted: Bool
    let tapAction: (() -> Void)?

    var body: some View {
        Button {
            tapAction?()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: isPermissionGranted ? "checkmark.square" : "square")
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityValue(Text(isPermissionGranted
            ? NSLocalizedString("Granted", comment: "Permission granted state")
            : NSLocalizedString("Not granted", comment: "Permission not granted state")))
    }
}
