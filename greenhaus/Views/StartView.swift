import SwiftUI

struct StartView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
            }
            DevicesView()
                .tabItem {
                    Image(systemName: "light.beacon.max.fill")
                    Text("Devices")
            }
            Text("Learn")
                .tabItem {
                    Image(systemName: "globe.desk.fill")
                    Text("Learn")
            }
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
            }
        }
        .navigationTitle("Greenhaus")
    }
}

#Preview {
    StartView()
}
