import SwiftUI

struct AppButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isEnabled ? .indigo : .blue.opacity(0.3))
            .foregroundStyle(isEnabled ? .white : .white.opacity(0.3))
            .font(.title3)
            .fontWeight(.bold)
            .clipShape(Capsule())
    }
}

struct IconButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? .white : .white.opacity(0.3))
            .padding()
            .background(isEnabled ? .indigo : .blue.opacity(0.3))
            .clipShape(Circle())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

#Preview {
    VStack {
        VStack {
            Text("AppButton")
            Button(
                action: {},
                label: { Text("Enabled Button") }
            )
            Button(
                action: {},
                label: { Text("Disabled Button") }
            )
            .disabled(true)
        }
        .padding()
        .buttonStyle(AppButton())

        VStack {
            Text("IconButton")
            Button(
                action: {},
                label: {
                    Image(
                        systemName: "person.crop.circle.fill"
                    )
                    .resizable()
                    .frame(width: 44, height: 44)
                }
            )
        }
        .padding()
        .buttonStyle(IconButton())
    }
    .foregroundStyle(.white)
    .font(.title)
    .fontWeight(.bold)
    .padding()
    .background(Color.teal)
}
