//
//  DiameterViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 09/09/25.
//

import SwiftUI
import ARKit
import SceneKit

/// Define o contrato que qualquer ViewModel responsável pela medição de diâmetro deve seguir.
///
/// Este protocolo especifica as propriedades e métodos essenciais para a funcionalidade
/// de medição, permitindo a substituição de implementações e facilitando testes.
protocol DiameterViewModelProtocol: AnyObject {
    
    // MARK: - Propriedades Obrigatórias
    
    /// Uma referência a um serviço que gerencia a câmera. A propriedade deve ser apenas de leitura ('get').
    var cameraService: CameraServiceProtocol { get }
    
    /// Uma string opcional para armazenar mensagens de erro. A propriedade deve ser apenas de leitura.
    var errorMessage: String? { get }
    
    // MARK: - Métodos Obrigatórios
    
    /// Adiciona um ponto 3D no centro da `ARSCNView` fornecida.
    /// - Parameter sceneView: A view da cena AR onde o ponto será adicionado.
    func addPointAtCenter(in sceneView: ARSCNView)
    
    /// Remove todos os nós (pontos, linhas, texto) da cena, resetando a medição.
    func resetNodes()
    
    /// Cria e retorna um nó de esfera (`SCNNode`) em uma posição 3D específica.
    /// - Parameter position: O vetor `SCNVector3` que define a localização da esfera.
    /// - Returns: Um `SCNNode` contendo uma geometria de esfera.
    func createSphere(at position: SCNVector3) -> SCNNode
    
    /// Calcula a distância escalar entre dois pontos no espaço 3D.
    /// - Parameters:
    ///   - start: O ponto inicial.
    ///   - end: O ponto final.
    /// - Returns: A distância (`Float`) entre os dois vetores.
    func distanceBetween(_ start: SCNVector3, _ end: SCNVector3) -> Float
    
    /// Cria e retorna um nó de texto 3D em uma posição específica.
    /// - Parameters:
    ///   - text: A string a ser exibida.
    ///   - position: A localização `SCNVector3` do texto na cena.
    /// - Returns: Um `SCNNode` contendo a geometria do texto.
    func addText(_ text: String, at position: SCNVector3) -> SCNNode
}
