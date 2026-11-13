import Foundation

struct Coffee: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let basePrice: Double
    let imageName: String
    var isAvailable: Bool

    init(id: UUID = UUID(), name: String, description: String, basePrice: Double, imageName: String, isAvailable: Bool = true) {
        self.id = id
        self.name = name
        self.description = description
        self.basePrice = basePrice
        self.imageName = imageName
        self.isAvailable = isAvailable
    }
}
