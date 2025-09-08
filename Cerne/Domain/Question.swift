//
//  Question.swift
//  Cerne
//
//  Created by Andrei Rech on 05/09/25.
//

struct Question: Codable, Identifiable {
    let id: Int
    let text: String
    let options: [Option]
}
