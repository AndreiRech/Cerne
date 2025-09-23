//
//  Pin.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import Foundation
import SwiftData

@Model
final class Pin: Identifiable {
    var id: UUID = UUID()
    @Attribute(.externalStorage) var image: Data?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var date: Date = Date()
    var reports: Int = 0
    
    @Relationship(deleteRule: .nullify, inverse: \User.pins)
    var user: User?
    
    @Relationship(deleteRule: .cascade, inverse: \ScannedTree.pin)
    var tree: ScannedTree?
    
    init(id: UUID = UUID(), image: Data, latitude: Double, longitude: Double, date: Date, reports: Int = 0, user: User, tree: ScannedTree) {
        self.id = id
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.reports = reports
        self.user = user
        self.tree = tree
    }
    
    var formattedTotalCO2: String {
        return String(format: "%.0f", tree?.totalCO2 ?? 0.0)
    }
        
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
