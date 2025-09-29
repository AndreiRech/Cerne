//
//  FootprintViewModelProtocol.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

protocol FootprintViewModelProtocol {
    var currentPage: Int { get }
    var selections: [CarbonEmittersEnum: String] { get set }
    
    var totalQuestionPages: Int { get }
    var totalPages: Int { get }
    var isAbleToSave: Bool { get }
    
    func emittersForPage(_ page: Int) -> [CarbonEmittersEnum]
    func updateSelection(for emitter: CarbonEmittersEnum, to newValue: String)
    func saveFootprint() async
    func calculateCarbonEmissions() -> (total: Double, responses: [Response])
    func loadUserSelections() async
}
