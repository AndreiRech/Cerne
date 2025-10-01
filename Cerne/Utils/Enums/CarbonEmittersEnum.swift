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
        case .shortHaulFlight: return "Voos domésticos" // Ajustado
        case .longHaulFlight: return "Voos internacionais" // Ajustado
        case .diet: return "Dieta"
        case .airConditioner: return "Ar condicionado"
        case .purchase: return "Compras" // Ajustado
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
        case .purchase: return "Com que frequência você compra roupas, eletrônicos ou móveis novos?" // Ajustado
        case .houseHold: return "Você usa eletrodomésticos de alto consumo (secadora, aquecedor)?" // Ajustado
        case .recicle: return "Como você lida com resíduos/reciclagem?"
        }
    }

    var iconName: String {
        switch self {
        case .car: return "car"
        case .km: return "road.lanes"
        case .bus: return "bus"
        case .shortHaulFlight: return "airplane"
        case .longHaulFlight: return "airplane" // Ícone unificado para voos, pode ser ajustado se necessário
        case .diet: return "fork.knife.circle"
        case .airConditioner: return "air.conditioner.horizontal" // Ícone mais específico para ar-condicionado
        case .purchase: return "cart" // Ícone mais genérico para compras
        case .houseHold: return "dryer"
        case .recicle: return "arrow.triangle.2.circlepath" // Ícone atualizado do sistema para reciclagem
        }
    }

    func getPickerOptions() -> [String] {
        // As opções já estavam corretas e alinhadas com o JSON.
        // Nenhuma alteração foi necessária aqui.
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
            return ["Selecionar", "Não uso", "Uso ocasionalmente", "Uso frequentemente"]
        case .purchase:
            return ["Selecionar", "Raramente", "Poucas vezes ao ano", "Algumas vezes ao ano", "Frequentemente"]
        case .houseHold:
            return ["Selecionar", "Quase nunca", "1 ou 2 ocasionalmente", "Alguns frequentemente", "Vários frequentemente"]
        case .recicle:
            return ["Selecionar", "Reciclo quase tudo", "Reciclo algumas coisas", "Reciclo pouco", "Não reciclo"]
        }
    }
}
