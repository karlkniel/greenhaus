import SwiftUI

struct ViewButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .bold()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

#Preview {
    ContentView()
}
