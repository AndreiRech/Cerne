// MockTreeDataService.swift

import Foundation
@testable import Cerne // Importa seu módulo para ter acesso aos tipos de dados

// 1. Defina o protocolo para que o mock possa implementá-lo.
//    É uma boa prática ter este protocolo em um arquivo separado.
protocol TreeDataServiceProtocol {
    func findTree(byScientificName scientificName: String) -> TreeDetails?
}

class MockTreeDataService: TreeDataServiceProtocol {
    
    // 2. Um array para guardar nossos dados falsos (mock data).
    //    Ele substitui a leitura do arquivo JSON.
    var mockTreeDetails: [TreeDetails]
    
    // 3. O inicializador permite injetar os dados que você quer usar em cada teste.
    //    Ele tem um valor padrão para facilitar a criação.
    init(mockDetails: [TreeDetails] = [
        TreeDetails(
            commonName: "Araucária",
            scientificName: "Araucaria angustifolia",
            density: 0.5,
            description: "Árvore símbolo do sul do Brasil."
        )
    ]) {
        self.mockTreeDetails = mockDetails
    }
    
    // 4. Implementação da função do protocolo.
    //    Esta função imita o comportamento da função real, mas busca os dados
    //    no nosso array `mockTreeDetails` em vez de ler do arquivo.
    func findTree(byScientificName scientificName: String) -> TreeDetails? {
        let searchName = scientificName.lowercased().trimmingCharacters(in: .whitespaces)
        
        // A lógica de busca é a mesma do seu serviço real, o que torna o mock fiel.
        let foundTree = mockTreeDetails.first { tree in
            return tree.scientificName.lowercased().trimmingCharacters(in: .whitespaces) == searchName
        }
        
        return foundTree
    }
}