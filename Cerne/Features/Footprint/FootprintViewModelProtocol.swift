//
//  FootprintViewModelProtocol.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

protocol FootprintViewModelProtocol {
    var currentPage: Int { get set }
    var selections: [CarbonEmittersEnum: Int] { get set }
    
    var totalQuestionPages: Int { get }
    var totalPages: Int { get }
    var isAbleToSave: Bool { get }
    var isLoading: Bool { get set }
    var isOverlayVisible: Bool { get }
    
    func fetchData() async
    func emittersForPage(_ page: Int) -> [CarbonEmittersEnum]
    func updateSelection(for emitter: CarbonEmittersEnum, to newOptionId: Int)
    func saveFootprint() async
    func calculateCarbonEmissions() -> (total: Double, responses: [ResponseData])
    func loadUserSelections()
}
