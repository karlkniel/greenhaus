import SwiftUI

struct BackgroundImage: View {
    var body: some View {
        Image("rocksAndPlants")
            .clipShape(Rectangle())
            .overlay {
                Rectangle().stroke(.white, lineWidth: 4)
            }
    }
}

#Preview {
    BackgroundImage()
}
