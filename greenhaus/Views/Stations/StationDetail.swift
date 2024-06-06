import SwiftUI

struct StationDetail: View {
    var station: Station
    
    var body: some View {
        VStack {
            BackgroundImage()
                .frame(height: 300)
                .padding(.top, 50)
            
            PlantImage(image: station.image)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text(station.name)
                    .font(.title)
                
                HStack {
                    Text(station.category)
                    Spacer()
                    Text(station.date)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                
                Text("About \(station.name)")
                    .font(.title2)
                Text(station.description)
            }
            .padding()
        }
        .navigationTitle(station.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    StationDetail(station: stations[0])
}
