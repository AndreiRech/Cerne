//
//  DiameterViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 09/09/25.
//

import SwiftUI
import ARKit
import SceneKit

/// O ViewModel responsável por toda a lógica de medição de diâmetro com ARKit.
///
/// Gerencia a sessão de AR, o estado da interface (ex: `showInfo`), a adição de pontos
/// na cena 3D, o cálculo da distância e a renderização de objetos como linhas e texto.
@Observable
class DiameterViewModel: NSObject, DiameterViewModelProtocol, ObservableObject, ARSCNViewDelegate {
    
    // MARK: - Propriedades de Estado e Resultado
    /// O resultado final da medição da distância, em metros.
    var result: Double? = nil
    /// Flag para controlar a navegação para a próxima tela.
    var shouldNavigate: Bool = false
    /// A imagem da árvore que foi capturada na tela anterior.
    var treeImage: UIImage
    
    // MARK: - Nós da Cena (SceneKit)
    /// O nó (ponto 3D) que marca o início da medição.
    var startNode: SCNNode?
    /// O nó que marca o fim da medição.
    var endNode: SCNNode?
    /// O nó que desenha a linha (régua) entre o ponto inicial e final.
    var lineNode: SCNNode?
    /// O nó que exibe o texto com o resultado da medição na cena 3D.
    var textNode: SCNNode?
    /// O nó para a linha-guia que aparece antes do segundo ponto ser adicionado.
    var guidelineNode: SCNNode?
    
    // MARK: - Serviços e Erros
    /// Um serviço para interagir com a câmera (injetado via dependência).
    var cameraService: CameraServiceProtocol
    /// Armazena uma mensagem de erro, caso ocorra.
    var errorMessage: String?
    
    // MARK: - Propriedades de Controle da UI
    /// Controla a exibição da tela de instruções iniciais.
    var showInfo: Bool = true
    /// Controla a exibição da dica "Adicionar um ponto".
    var showAddPointHint: Bool = false
    /// Gatilho booleano para comunicar à `ARSceneView` que um ponto deve ser adicionado.
    var placePointTrigger: Bool = false
    
    // MARK: - Propriedades de AR
    /// A view principal do ARKit que renderiza a cena.
    let sceneView = ARSCNView()
    /// Flag para garantir que a sessão de AR seja reiniciada apenas na primeira execução.
    private var hasRunOnce = false

    let onboardingService: OnboardingServiceProtocol
    var errorMessage: String?
    
    /// Inicializador do ViewModel.
    /// - Parameters:
    ///   - cameraService: O serviço de câmera a ser utilizado.
    ///   - treeImage: A imagem da árvore para ser passada adiante.
    init() {

    
    init(cameraService: CameraServiceProtocol, treeImage: UIImage, onboardingService: OnboardingServiceProtocol) {
        self.cameraService = cameraService
        self.onboardingService = onboardingService
        self.treeImage = treeImage
        super.init() // Necessário por herdar de NSObject
        setupSceneView()
    }
    
    /// Configurações iniciais da `sceneView`.
    private func setupSceneView() {
        sceneView.delegate = self // Define esta classe como o delegate para receber eventos da cena.
        sceneView.autoenablesDefaultLighting = true // Adiciona iluminação padrão para objetos 3D.
    }
    
    // MARK: - Gerenciamento da Sessão de AR
    
    /// Inicia ou retoma a sessão de Realidade Aumentada.
    func runSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical] // Habilita a detecção de planos verticais.
        configuration.environmentTexturing = .automatic // Melhora o realismo dos objetos 3D.
        
        if hasRunOnce {
            // Se a sessão já rodou antes, apenas a retoma.
            sceneView.session.run(configuration)
        } else {
            // Na primeira vez, reseta o rastreamento e remove âncoras existentes.
            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            hasRunOnce = true
        }
    }
    
    /// Pausa a sessão de AR para economizar recursos.
    func pauseSession() {
        sceneView.session.pause()
    }
    
    // MARK: - Lógica de Medição
    
    /// Adiciona um ponto de medição no centro da tela.
    /// Utiliza **raycasting** para projetar um raio do centro da tela para o mundo real.
    func addPointAtCenter(in sceneView: ARSCNView) {
        let centerPoint = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
        
        // Cria uma consulta de raycast a partir do ponto central.
        guard let query = sceneView.raycastQuery(from: centerPoint, allowing: .estimatedPlane, alignment: .horizontal) else {
            return
        }
        
        // Executa a consulta e pega o primeiro resultado.
        let results = sceneView.session.raycast(query)
        guard let result = results.first else {
            return
        }
        
        // Extrai a posição 3D do resultado do raycast.
        let position = SCNVector3(
            result.worldTransform.columns.3.x,
            result.worldTransform.columns.3.y,
            result.worldTransform.columns.3.z
        )
        
        if startNode == nil {
            // Se for o primeiro ponto, cria o nó inicial.
            startNode = createSphere(at: position)
            sceneView.scene.rootNode.addChildNode(startNode!)
            
        } else if endNode == nil {
            // Se for o segundo ponto, cria o nó final e finaliza a medição.
            endNode = createSphere(at: position)
            sceneView.scene.rootNode.addChildNode(endNode!)
            
            // Desenha a linha (régua) entre os dois pontos.
            lineNode = drawRuler(from: startNode!.position, to: endNode!.position)
            sceneView.scene.rootNode.addChildNode(lineNode!)
            
            // Calcula a distância.
            let distance = distanceBetween(startNode!.position, endNode!.position)
            
            // Calcula o ponto médio para posicionar o texto.
            let midPoint = SCNVector3(
                (startNode!.position.x + endNode!.position.x) / 2,
                (startNode!.position.y + endNode!.position.y) / 2 + 0.01, // Um pouco acima da linha
                (startNode!.position.z + endNode!.position.z) / 2
            )
            
            // Adiciona o texto com a distância na cena.
            let text = String(format: "%.2f m", distance)
            textNode = addText(text, at: midPoint)
            sceneView.scene.rootNode.addChildNode(textNode!)
            
            // Armazena o resultado final.
            self.result = Double(distance)
        }
    }
    
    /// Ativa o gatilho que fará a `ARSceneView` chamar `addPointAtCenter`.
    func triggerPointPlacement() {
        placePointTrigger = true
    }
    
    /// Método do delegate `ARSCNViewDelegate`, chamado a cada atualização de frame.
    /// Usado para desenhar a linha-guia em tempo real.
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Só executa se o primeiro ponto foi adicionado, mas o segundo ainda não.
        guard let startNode = self.startNode, self.endNode == nil else {
            // Garante que a linha-guia seja removida se não for mais necessária.
            DispatchQueue.main.async {
                self.guidelineNode?.removeFromParentNode()
                self.guidelineNode = nil
            }
            return
        }
        
        // Atualiza a linha-guia a partir do ponto inicial até a mira atual.
        DispatchQueue.main.async {
            let centerPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
            guard let query = self.sceneView.raycastQuery(from: centerPoint, allowing: .estimatedPlane, alignment: .horizontal),
                  let result = self.sceneView.session.raycast(query).first else {
                return
            }
            
            let worldPosition = SCNVector3(
                result.worldTransform.columns.3.x,
                result.worldTransform.columns.3.y,
                result.worldTransform.columns.3.z
            )
            
            // Remove a linha antiga e desenha uma nova na posição atualizada.
            self.guidelineNode?.removeFromParentNode()
            self.guidelineNode = self.drawLine(from: startNode.position, to: worldPosition, color: .white)
            self.sceneView.scene.rootNode.addChildNode(self.guidelineNode!)
        }
    }
    
    // MARK: - Funções de Controle de Estado
    
    /// Reseta todos os nós e o estado da medição para permitir uma nova tentativa.
    func resetNodes() {
        startNode?.removeFromParentNode()
        endNode?.removeFromParentNode()
        lineNode?.removeFromParentNode()
        textNode?.removeFromParentNode()
        guidelineNode?.removeFromParentNode()
        
        startNode = nil
        endNode = nil
        lineNode = nil
        textNode = nil
        guidelineNode = nil
        result = nil
    }
    
    /// Prepara para a navegação para a próxima tela.
    func finishMeasurement() {
        if let distance = result, distance > 0 {
            shouldNavigate = true
        }
    }
    
    // MARK: - Métodos Auxiliares de Desenho (SceneKit)
    
    /// Cria um nó de esfera vermelha para marcar um ponto.
    func createSphere(at position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: sphere)
        node.position = position
        return node
    }
    
    /// Calcula a distância euclidiana entre dois pontos 3D.
    func distanceBetween(_ start: SCNVector3, _ end: SCNVector3) -> Float {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let dz = end.z - start.z
        return sqrt(dx*dx + dy*dy + dz*dz)
    }
    
    /// Cria um nó de texto 3D.
    func addText(_ text: String, at position: SCNVector3) -> SCNNode {
        let textGeometry = SCNText(string: text, extrusionDepth: 0.01)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        textGeometry.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        
        let node = SCNNode(geometry: textGeometry)
        node.scale = SCNVector3(0.005, 0.005, 0.005) // Reduz o tamanho do texto.
        node.position = position
        
        // Faz o texto sempre ficar virado para a câmera.
        let constraint = SCNBillboardConstraint()
        node.constraints = [constraint]
        
        return node
    }
    
    /// Desenha uma linha principal com pequenas marcações, como uma régua.
    func drawRuler(from start: SCNVector3, to end: SCNVector3, interval: Float = 0.1) -> SCNNode {
        let rulerNode = SCNNode()
        let mainLine = drawLine(from: start, to: end)
        rulerNode.addChildNode(mainLine)
        
        let dx = end.x - start.x
        let dy = end.y - start.y
        let dz = end.z - start.z
        let length = sqrt(dx*dx + dy*dy + dz*dz)
        let steps = Int(length / interval) // Calcula quantos "ticks" de 10cm cabem na linha.
        if steps == 0 { return rulerNode }
        
        let stepVector = SCNVector3(dx / Float(steps), dy / Float(steps), dz / Float(steps))
        
        // Adiciona um "tick" (marcação) a cada intervalo.
        for i in 0...steps {
            let tickPosition = SCNVector3(
                start.x + stepVector.x * Float(i),
                start.y + stepVector.y * Float(i),
                start.z + stepVector.z * Float(i)
            )
            let tick = drawTick(at: tickPosition, size: 0.005)
            rulerNode.addChildNode(tick)
        }
        
        return rulerNode
    }
    
    /// Desenha uma linha simples entre dois pontos.
    private func drawLine(from start: SCNVector3, to end: SCNVector3, color: UIColor = .yellow) -> SCNNode {
        let vertices: [SCNVector3] = [start, end]
        let source = SCNGeometrySource(vertices: vertices)
        let indices: [Int32] = [0, 1]
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.firstMaterial?.diffuse.contents = color
        return SCNNode(geometry: geometry)
    }
    
    /// Desenha uma pequena marcação (um cilindro fino) em uma posição.
    private func drawTick(at position: SCNVector3, size: Float) -> SCNNode {
        let tickGeometry = SCNCylinder(radius: 0.0005, height: CGFloat(size))
        tickGeometry.firstMaterial?.diffuse.contents = UIColor.white
        let tickNode = SCNNode(geometry: tickGeometry)
        tickNode.position = position
        tickNode.eulerAngles.x = .pi / 2 // Rotaciona para ficar perpendicular à linha principal.
        return tickNode
    }
}
