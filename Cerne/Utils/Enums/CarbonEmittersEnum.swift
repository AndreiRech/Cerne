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
        case .car: return String(localized: "Carro")
        case .km: return String(localized: "Quilometragem de carro")
        case .bus: return String(localized: "Transporte público")
        case .shortHaulFlight: return String(localized: "Voos domésticos")
        case .longHaulFlight: return String(localized: "Voos internacionais")
        case .diet: return String(localized: "Dieta")
        case .airConditioner: return String(localized: "Ar condicionado")
        case .purchase: return String(localized: "Compras")
        case .houseHold: return String(localized: "Eletrodomésticos de alto consumo")
        case .recicle: return String(localized: "Resíduos e reciclagem")
        }
    }

    var description: String {
        switch self {
        case .car: return String(localized: "Qual tipo de combustível o seu carro usa?")
        case .km: return String(localized: "Quantos quilômetros você dirige por semana?")
        case .bus: return String(localized: "Quantos quilômetros você percorre de transporte público por semana?")
        case .shortHaulFlight: return String(localized: "Quantos voos domésticos você faz por ano?")
        case .longHaulFlight: return String(localized: "Quantos voos internacionais você faz por ano?")
        case .diet: return String(localized: "Adota alguma dieta ou restrição alimentar?")
        case .airConditioner: return String(localized: "Com que frequência você usa ar-condicionado?")
        case .purchase: return String(localized: "Com que frequência você compra roupas, eletrônicos ou móveis novos?")
        case .houseHold: return String(localized: "Você usa eletrodomésticos de alto consumo (secadora, aquecedor)?")
        case .recicle: return String(localized: "Como você lida com resíduos/reciclagem?")
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
            return [String(localized: "Selecionar"), String(localized: "Não tenho carro"), String(localized: "Gasolina / Álcool"), String(localized: "Diesel"), String(localized: "Híbrido / Elétrico")]
        case .km:
            return [String(localized: "Selecionar"), String(localized: "0 km"), String(localized: "Menos de 50 km"), String(localized: "50-150 km"), String(localized: "Mais de 150 km")]
        case .bus:
            return [String(localized: "Selecionar"), String(localized: "0 km"), String(localized: "Menos de 50 km"), String(localized: "50-150 km"), String(localized: "Mais de 150 km")]
        case .shortHaulFlight:
            return [String(localized: "Selecionar"), String(localized: "0 voos"), String(localized: "1-2 voos"), String(localized: "3-5 voos"), String(localized: "6 ou mais voos")]
        case .longHaulFlight:
            return [String(localized: "Selecionar"), String(localized: "0 voos"), String(localized: "1 voo"), String(localized: "2 voos"), String(localized: "3 ou mais voos")]
        case .diet:
            return [String(localized: "Selecionar"), String(localized: "Vegana"), String(localized: "Vegetariana"), String(localized: "Consumo pouca carne"), String(localized: "Consumo carne diariamente")]
        case .airConditioner:
            return [String(localized: "Selecionar"), String(localized: "Não uso"), String(localized: "Uso ocasionalmente"), String(localized: "Uso frequentemente")]
        case .purchase:
            return [String(localized: "Selecionar"), String(localized: "Raramente"), String(localized: "Poucas vezes ao ano"), String(localized: "Algumas vezes ao ano"), String(localized: "Frequentemente")]
        case .houseHold:
            return [String(localized: "Selecionar"), String(localized: "Quase nunca"), String(localized: "1 ou 2 ocasionalmente"), String(localized: "Alguns frequentemente"), String(localized: "Vários frequentemente")]
        case .recicle:
            return [String(localized: "Selecionar"), String(localized: "Reciclo quase tudo"), String(localized: "Reciclo algumas coisas"), String(localized: "Reciclo pouco"), String(localized: "Não reciclo")]
        }
    }
}
