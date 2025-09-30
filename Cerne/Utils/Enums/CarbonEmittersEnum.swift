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
        case .airConditioner: return "Com qual frequência você usa aquecimento/ar-condicionado?"
        case .car: return "Qual tipo de combustível o seu carro usa?"
        case .km: return "Quantos quilômetros você dirige por semana?"
        case .bus: return "Quantos quilômetros você percorre de transporte público por semana?"
        case .shortHaulFlight: return "Quantos voos de curta distância (domésticos) você faz por ano?"
        case .longHaulFlight: return "Quantos voos de longa distância (internacionais) você faz por ano?"
        case .diet: return "Qual é a sua dieta?"
        case .purchase: return "Com que frequência você compra roupas, eletrônicos ou móveis novos?"
        case .recicle: return "Como você lida com resíduos/reciclagem?"
        case .houseHold: return "Você usa eletrodomésticos de alto consumo (secadora, aquecedor elétrico, sauna etc.)?"
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
            return ["Selecionar", "0 km", "Menos de 50 km", "50-150 km", "Mais de 150 km"]
        case .bus:
            return ["Selecionar", "0 km", "Menos de 50 km", "50-150 km", "Mais de 150 km"]
        case .shortHaulFlight:
            return ["Selecionar", "0 voos", "1-2 voos", "3-5 voos", "6 ou mais voos"]
        case .longHaulFlight:
            return ["Selecionar", "0 voos", "1 voo", "2 voos", "3 ou mais voos"]
        case .diet:
            return ["Selecionar", "Vegana", "Vegetariana", "Consumo pouca carne", "Consumo carne diariamente"]
        case .airConditioner:
            return ["Selecionar", "Não uso (ou quase nunca)", "Uso ocasional (algumas semanas por ano)", "Uso frequente (várias horas/dia em temporadas)"]
        case .purchase:
            return ["Selecionar", "Muito raramente (só quando necessário)", "Poucas vezes por ano (baixo consumo)", "Algumas vezes por ano (uso médio)", "Frequentemente (uso alto)"]
        case .recicle:
            return ["Selecionar", "Reciclo quase tudo", "Reciclo algumas coisas", "Reciclo pouco", "Não reciclo"]
        case .houseHold:
            return ["Selecionar", "Quase nenhum", "1 ou 2 aparelhos ocasionalmente", "Alguns frequentemente", "Vários frequentemente"]
        }
    }
}
