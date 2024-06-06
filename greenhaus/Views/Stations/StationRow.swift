import SwiftUI

struct StationRow: View {
    var station: Station
    
    var body: some View {
        HStack {
            station.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(station.name)
            
            Spacer()
        }
    }
}

#Preview {
    Group {
        StationRow(station: stations[0])
        StationRow(station: stations[1])
    }
}
