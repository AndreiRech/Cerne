//
//  CarbonEmittersEnum.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

import SwiftUI

enum CarbonEmittersEnum: CaseIterable {
    case car
    case km
    case bus
    case shortHaulFlight
    case longHaulFlight
    case diet
    case airConditioner
    case purchase
    case houseHold
    case recicle
    
    var title: String {
        switch self {
        case .car: return "Carro"
        case .km: return "Quilometragem de carro"
        case .bus: return "Transporte público"
        case .shortHaulFlight: return "Voos de curta distância"
        case .longHaulFlight: return "Voos de longa distância"
        case .diet: return "Dieta"
        case .airConditioner: return "Ar condicionado"
        case .purchase: return "Consumos de bens"
        case .houseHold: return "Eletrodomésticos de alto consumo"
        case .recicle: return "Resíduos e reciclagem"
        }
    }
    
    var description: String {
        switch self {
        case .car: return "Qual tipo de combustível o seu carro usa?"
        case .km: return "Quantos quilômetros você dirige por semana?"
        case .bus: return "Quantos quilômetros você percorre de transporte público por semana?"
        case .shortHaulFlight: return "Quantos voos domésticos você faz por ano?"
        case .longHaulFlight: return "Quantos voos internacionais você faz por ano?"
        case .diet: return "Adota alguma dieta ou restrição alimentar?"
        case .airConditioner: return "Com que frequência você usa ar-condicionado?"
        case .purchase: return "Com que frequência você compra roupas, eletrônicos ou móveis novos?"
        case .houseHold: return "Você usa eletrodomésticos de alto consumo (secadora, aquecedor)?"
        case .recicle: return "Como você lida com resíduos/reciclagem?"
        }
    }
    
    var iconName: String {
        switch self {
        case .car: return "car"
        case .km: return "road.lanes"
        case .bus: return "bus"
        case .shortHaulFlight: return "airplane"
        case .longHaulFlight: return "airplane.path.dotted"
        case .diet: return "fork.knife.circle"
        case .airConditioner: return "air.purifier"
        case .purchase: return "chair.lounge"
        case .houseHold: return "dryer"
        case .recicle: return "arrow.trianglehead.2.clockwise.rotate.90"
        }
    }
    
    func getPickerOptions() -> [String] {
        switch self {
        case .car:
            return ["Selecionar", "Não tenho carro", "Gasolina / Álcool", "Diesel", "Híbrido / Elétrico"]
        case .km:
            return ["Selecionar", "0 km", "1 - 100 km", "101 - 300 km", "Mais de 300 km"]
        case .bus:
            return ["Selecionar", "0 km", "1 - 50 km", "51 - 150 km", "Mais de 150 km"]
        case .shortHaulFlight:
            return ["Selecionar", "Nenhum", "1 - 2 voos", "3 - 5 voos", "Mais de 5 voos"]
        case .longHaulFlight:
            return ["Selecionar", "Nenhum", "1 - 2 voos", "3 - 5 voos", "Mais de 5 voos"]
        case .diet:
            return ["Selecionar", "0 km", "1 - 100 km", "101 - 300 km", "Mais de 300 km"]
        case .airConditioner:
            return ["Selecionar", "0 km", "1 - 50 km", "51 - 150 km", "Mais de 150 km"]
        case .purchase:
            return ["Selecionar", "Nenhum", "1 - 2 voos", "3 - 5 voos", "Mais de 5 voos"]
        case .houseHold:
            return ["Selecionar", "Nenhum", "1 - 2 voos", "3 - 5 voos", "Mais de 5 voos"]
        case .recicle:
            return ["Selecionar", "Nenhum", "1 - 2 voos", "3 - 5 voos", "Mais de 5 voos"]
        }
    }
}
