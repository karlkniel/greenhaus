import Foundation
import SwiftUI

struct Station: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var date: String
    var category: String
    var description: String
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    private var measurements: Measurements
    struct Measurements: Hashable, Codable {
        var airTemp: String
        var humidity: String
        var soilTemp: String
        var soilMoisture: String
        var pressure: String
    }
}
