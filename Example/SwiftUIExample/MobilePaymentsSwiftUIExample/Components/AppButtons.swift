import SwiftUI

struct HeaderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.Button.Header.background)
            .foregroundStyle(Color.Button.Header.foreground)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .font(.body.weight(.semibold))
            .clipShape(.rect(cornerRadius: 6))
    }
}

struct BuyButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(isEnabled ? Color.Button.Buy.enabledBackground : Color.Button.Buy.disabledBackground)
            .foregroundStyle(isEnabled ? Color.Button.Buy.enabledForeground : Color.Button.Buy.disabledForeground)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .clipShape(.rect(cornerRadius: 6))
    }
}

struct AuthorizationButtonStyle: ButtonStyle {
    var isAuthorized: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(isAuthorized ? Color.Button.Authorization.authorizedBackground : Color.Button.Authorization.notAuthorizedBackground)
            .foregroundStyle(isAuthorized ? Color.Button.Authorization.authorizedForeground : Color.Button.Authorization.notAuthorizedForeground)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .clipShape(.rect(cornerRadius: 6))
    }
}

struct MockReaderButtonStyle: ButtonStyle {
    var isPresented: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(isPresented ? Color.Button.MockReader.hideMockReaderBackground : Color.Button.MockReader.showMockReaderBackground)
            .foregroundStyle(Color.Button.MockReader.foreground)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .clipShape(.rect(cornerRadius: 6))
    }
}

struct DismissButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 24, height: 24)
            .padding(12)
            .background(Color.Button.Dismiss.background)
            .foregroundStyle(Color.Button.Dismiss.foreground)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .clipShape(.rect(cornerRadius: 6))
    }
}

#Preview {
    VStack {
        Button(
            action: {},
            label: { Text("Header Button") }
        )
        .padding()
        .buttonStyle(HeaderButtonStyle())
        
        Button(
            action: {},
            label: {
                Image(systemName: "xmark")
                    .font(.body)
                    .fontWeight(.medium)
            }
        )
        .padding()
        .buttonStyle(DismissButton())
        
        Button(
            action: {},
            label: { Text("Enabled Buy Button") }
        )
        .padding()
        .buttonStyle(BuyButtonStyle())
        
        Button(
            action: {},
            label: { Text("Disabled Buy Button") }
        )
        .padding()
        .disabled(true)
        .buttonStyle(BuyButtonStyle())
        
        Button(
            action: {},
            label: { Text("Sign In") }
        )
        .padding()
        .buttonStyle(AuthorizationButtonStyle(isAuthorized: false))
        
        Button(
            action: {},
            label: { Text("Sign out") }
        )
        .padding()
        .buttonStyle(AuthorizationButtonStyle(isAuthorized: true))
        
        Button(
            action: {},
            label: {
                ProgressView()
                    .tint(.black)
            }
        )
        .padding()
        .buttonStyle(AuthorizationButtonStyle(isAuthorized: false))
    }
    .padding()
    .background(Color.white)
    .font(.headline)
}
