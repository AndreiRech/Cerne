//
//  MonthlyData.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 30/09/25.
//

import SwiftUI

struct MonthlyData: Identifiable {
    let id = UUID()
    let month: String
    let normalizedHeight: Double
}
